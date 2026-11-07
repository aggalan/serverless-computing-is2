#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for f in index.html aws-demo/template.yaml aws-demo/src/app.py aws-demo/tests/test_app.py docs/GUIA_AWS.md docs/GUION.md; do test -s "$f"; done
python3 -m unittest discover -s aws-demo/tests -v
