import json
import sys
import unittest
from pathlib import Path
from botocore.exceptions import ClientError
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from app import handle

def evt(method, path, body=None):
    return {"requestContext": {"http": {"method": method}}, "rawPath": path,
            "body": json.dumps(body) if body is not None else None}

class FakeTable:
    def __init__(self): self.data = {}
    def put_item(self, Item, ConditionExpression):
        key = Item["registration_id"]
        assert ConditionExpression == "attribute_not_exists(registration_id)"
        if key in self.data:
            raise ClientError({"Error": {"Code": "ConditionalCheckFailedException", "Message": "exists"}}, "PutItem")
        self.data[key] = Item
    def get_item(self, Key, ConsistentRead=False):
        return {"Item": self.data.get(Key["registration_id"])}
    def scan(self, Limit, ConsistentRead=False):
        return {"Items": list(self.data.values())[:Limit]}

class DemoTests(unittest.TestCase):
    def setUp(self): self.table = FakeTable()
    def payload(self, res): return json.loads(res["body"])
    def test_health(self):
        self.assertEqual(handle(evt("GET","/health"),self.table)["statusCode"],200)
    def test_create_and_retry(self):
        data={"request_id":"demo-01234567","name":"Ada"}
        self.assertEqual(handle(evt("POST","/registrations",data),self.table)["statusCode"],201)
        r=handle(evt("POST","/registrations",data),self.table)
        self.assertEqual(r["statusCode"],200)
        self.assertTrue(self.payload(r)["duplicate"])
        self.assertEqual(len(self.table.data),1)
    def test_id_conflict(self):
        handle(evt("POST","/registrations",{"request_id":"demo-01234567","name":"Ada"}),self.table)
        r=handle(evt("POST","/registrations",{"request_id":"demo-01234567","name":"Grace"}),self.table)
        self.assertEqual(r["statusCode"],409)
    def test_get_list(self):
        handle(evt("POST","/registrations",{"request_id":"demo-01234567","name":"Ada"}),self.table)
        self.assertEqual(self.payload(handle(evt("GET","/registrations"),self.table))["shown"],1)
    def test_invalid_body(self):
        for body in [{"request_id":"x","name":"Ada"},{"request_id":"demo-01234567","name":""}]:
            self.assertEqual(handle(evt("POST","/registrations",body),self.table)["statusCode"],400)
    def test_missing_route(self):
        self.assertEqual(handle(evt("GET","/nope"),self.table)["statusCode"],404)

if __name__=="__main__": unittest.main()
