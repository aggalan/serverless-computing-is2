"""ITBA Serverless Computing demo: API Gateway -> Lambda -> DynamoDB.
Teaching PoC only: intentionally unauthenticated and not production-ready.
"""
import json
import logging
import os
import re
from datetime import datetime, timezone
import boto3
from botocore.exceptions import ClientError

LOG = logging.getLogger(__name__)
LOG.setLevel(logging.INFO)
ID_PATTERN = re.compile(r"^[a-zA-Z0-9_-]{8,64}$")

def _response(code, payload):
    return {
        "statusCode": code,
        "headers": {"Content-Type": "application/json; charset=utf-8", "Cache-Control": "no-store"},
        "body": json.dumps(payload, ensure_ascii=False, separators=(",", ":"))
    }

def handle(event, table):
    method = (event.get("requestContext", {}).get("http", {}).get("method")
              or event.get("httpMethod") or "GET").upper()
    path = event.get("rawPath") or event.get("path") or "/"
    if method == "GET" and path == "/health":
        return _response(200, {"ok": True, "service": "serverless-itba-demo", "mode": "aws",
                               "now": datetime.now(timezone.utc).isoformat()})
    if method == "GET" and path == "/registrations":
        try:
            scan = table.scan(Limit=50, ConsistentRead=True)
            items = scan.get("Items", [])
            items.sort(key=lambda x: x.get("created_at", ""), reverse=True)
            return _response(200, {"items": items, "shown": len(items),
                                   "has_more": bool(scan.get("LastEvaluatedKey"))})
        except ClientError:
            LOG.exception("DynamoDB scan failed")
            return _response(503, {"error": "database_unavailable"})
    if method == "POST" and path == "/registrations":
        try:
            body = json.loads(event.get("body") or "{}")
            if not isinstance(body, dict):
                raise ValueError("expected_object")
        except (ValueError, TypeError):
            return _response(400, {"error": "invalid_json"})
        request_id = body.get("request_id")
        name = body.get("name")
        if not isinstance(request_id, str) or not ID_PATTERN.fullmatch(request_id):
            return _response(400, {"error": "invalid_request_id", "hint": "8-64 alphanumeric, _ or -"})
        if not isinstance(name, str) or not 1 <= len(name.strip()) <= 60:
            return _response(400, {"error": "invalid_name", "hint": "1-60 characters"})
        name = name.strip()
        record = {"registration_id": request_id, "name": name, "event": "Serverless Lab",
                  "created_at": datetime.now(timezone.utc).isoformat()}
        try:
            table.put_item(Item=record, ConditionExpression="attribute_not_exists(registration_id)")
            LOG.info(json.dumps({"operation": "registration_created", "request_id": request_id}))
            return _response(201, {"created": True, "duplicate": False, "registration": record})
        except ClientError as exc:
            if exc.response.get("Error", {}).get("Code") != "ConditionalCheckFailedException":
                LOG.exception("DynamoDB put_item failed")
                return _response(503, {"error": "database_unavailable"})
            try:
                old = table.get_item(Key={"registration_id": request_id}, ConsistentRead=True).get("Item")
            except ClientError:
                LOG.exception("DynamoDB get_item failed")
                return _response(503, {"error": "database_unavailable"})
            if old and old.get("name") == name:
                LOG.info(json.dumps({"operation": "idempotent_retry", "request_id": request_id}))
                return _response(200, {"created": False, "duplicate": True, "registration": old})
            return _response(409, {"error": "idempotency_key_reused",
                                   "hint": "Same ID cannot represent distinct registrations"})
    return _response(404, {"error": "route_not_found", "path": path, "method": method})

def lambda_handler(event, context):
    table = boto3.resource("dynamodb").Table(os.environ["REGISTRATIONS_TABLE"])
    return handle(event, table)
