#!/usr/bin/env bash
# Hook: Warn if webhook handler files lack signature verification
# Event: PostToolUse (file edits)

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.toolInput.filePath // .toolInput.file_path // empty' 2>/dev/null || true)

# Skip if no file path or not a webhook handler
if [[ -z "$FILE_PATH" ]] || [[ ! "$FILE_PATH" =~ handlers/.*[Ww]ebhook|handlers/.*[Hh]ook ]]; then
  echo '{"continue": true}'
  exit 0
fi

# Skip if file doesn't exist yet
if [[ ! -f "$FILE_PATH" ]]; then
  echo '{"continue": true}'
  exit 0
fi

# Check for signature verification patterns
if ! grep -qiE 'verifyPcoSignature|x-pco-webhooks-authenticity|x-goog-channel-token|hmac|timingSafeEqual|verify.*(signature|token)' "$FILE_PATH" 2>/dev/null; then
  echo '{
    "continue": true,
    "systemMessage": "WARNING: This webhook handler does not appear to include signature/token verification. Google Calendar handlers must check X-Goog-Channel-Token. PCO handlers must verify HMAC-SHA256 from X-PCO-Webhooks-Authenticity. See webhook-handler instructions."
  }'
  exit 0
fi

echo '{"continue": true}'
