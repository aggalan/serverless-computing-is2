#!/usr/bin/env bash
set -euo pipefail
API_URL="${1:?Usage: ./scripts-smoke-test.sh https://your-api-url}"
API_URL="${API_URL%/}"
curl -fsS "$API_URL/health"; echo
curl -fsS -X POST "$API_URL/registrations" -H 'Content-Type: application/json' -d '{"request_id":"manual-12345","name":"Ada"}'; echo
curl -fsS "$API_URL/registrations"; echo
