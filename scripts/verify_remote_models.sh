#!/usr/bin/env bash

ENDPOINT=$1
TOKEN=$2

if [ -z "$ENDPOINT" ]; then
  echo "Usage: verify_remote_models.sh <endpoint> [token]"
  exit 1
fi

echo "Checking models endpoint..."

if [ -z "$TOKEN" ]; then
  curl "$ENDPOINT/v1/models"
else
  curl "$ENDPOINT/v1/models" \
    -H "Authorization: Bearer $TOKEN"
fi

echo
echo "Done."
