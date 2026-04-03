---
name: webhook-handler
description: "Use when: editing webhook handler files for Google Calendar or PCO webhooks; apply webhook security and processing best practices"
applyTo: "**/handlers/**/*webhook*.*,**/handlers/**/*hook*.*"
---

# Webhook Handler Instructions

Guidance for Lambda handlers that receive webhooks from Google Calendar or PCO.

## Guidance

### Security — MANDATORY

- **Verify webhook signatures before processing any payload**
  - Google Calendar: Validate `X-Goog-Channel-Token` matches your stored token
  - PCO: Verify HMAC-SHA256 of request body against `X-PCO-Webhooks-Authenticity` using shared secret with timing-safe comparison
- Return 200 even for invalid signatures — don't leak verification failure info
- Log signature failures at warn level (don't log the payload)

### Response Pattern

- Return 200 immediately — never return 4xx/5xx for transient errors
- For heavy processing (>5s), push to SQS and return 200 synchronously
- Only return 4xx for permanently bad requests (malformed, wrong content type)

### Idempotency

- Extract a unique delivery ID from headers and check DynamoDB before processing
- Use conditional writes to handle race conditions
- Write the processed marker after successful processing, not before

### Handler Structure

```
1. Parse event (API Gateway → extract headers + body)
2. Verify signature
3. Check idempotency (already processed?)
4. Extract webhook type/action
5. Delegate to sync service
6. Mark as processed
7. Return 200
```

For Google/PCO webhook header details and setup flows, see the `webhook-sync` skill.
2. Verify signature
3. Check idempotency (already processed?)
4. Extract webhook type/action
5. Delegate to sync service
6. Mark as processed
7. Return 200
```
