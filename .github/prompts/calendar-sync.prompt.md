---
name: calendar-sync
description: "Use when: need to set up bidirectional calendar sync between Google Calendar and PCO Calendar; generates full sync pipeline"
params:
  - name: language
    description: "TypeScript or Python"
  - name: conflict-strategy
    description: "Conflict resolution strategy (last-write-wins, google-wins, pco-wins)"
  - name: async
    description: "Whether to use SQS for async processing (yes/no)"
---

# Calendar Sync Pipeline

Set up a complete bidirectional sync pipeline between Google Calendar and Planning Center Online Calendar.

## Input Parameters

- **language**: TypeScript or Python
- **conflict-strategy**: How to resolve conflicts when both sides change
- **async**: Whether to decouple webhook receipt from processing via SQS

## What It Does

Scaffolds the full sync pipeline:
1. Google Calendar webhook handler Lambda
2. PCO Calendar webhook handler Lambda
3. Canonical CalendarEvent types
4. Field mapper (Google ↔ canonical ↔ PCO)
5. Sync service with conflict resolution
6. DynamoDB tables for ID mappings and idempotency
7. Terraform for all infrastructure (API Gateway, Lambdas, DynamoDB, IAM)
8. Tests for field mapping and sync logic

Use the `webhook-sync` skill templates as the basis for generated files.
Use the `lambda-scaffold` skill for project boilerplate.
Use the `api-integration` skill for API client patterns.

## Tips

- Start with `last-write-wins` conflict strategy — it's simplest and works for most cases
- Use SQS (`async: yes`) if sync processing might take > 10 seconds
- Google Calendar requires a scheduled Lambda to renew push notification channels (they expire)
- Create the sync state DynamoDB table before deploying handlers
