---
name: webhook-handler
description: "Use when: need to create a webhook handler Lambda for Google Calendar or PCO; generates handler with signature verification and idempotency"
params:
  - name: source
    description: "Webhook source (google-calendar, pco-calendar)"
  - name: language
    description: "TypeScript or Python"
  - name: events
    description: "Which events to handle (created, updated, destroyed — comma-separated)"
---

# Webhook Handler

Scaffold a webhook handler Lambda that receives and processes webhook events from Google Calendar or Planning Center Online.

## Input Parameters

- **source**: Which system sends the webhook (google-calendar, pco-calendar)
- **language**: TypeScript or Python
- **events**: Which event types to handle

## What It Does

Generates a webhook handler including:
1. Signature/token verification (Google: channel token, PCO: HMAC-SHA256)
2. Idempotency check using DynamoDB
3. Event type routing (created, updated, destroyed)
4. Delegation to sync service
5. Structured logging with aws-lambda-powertools
6. Proper 200 responses (never leak errors to webhook sender)

Use the `webhook-sync` skill templates as the basis for generated files.

## Tips

- Google Calendar webhooks don't include event data — you must call `events.list` with a `syncToken` to get changes
- PCO webhooks include the full resource in JSON:API format
- Always return 200 to webhook senders, even on errors — returning 4xx/5xx causes the sender to retry or disable
- For heavy processing, push to SQS and return 200 immediately
