---
name: webhook-sync
description: "Use when: building a webhook-driven sync pipeline between two APIs, setting up Google Calendar or PCO Calendar webhooks, creating bidirectional data sync; helps with reliable event-driven sync patterns"
---

# Webhook Sync Skill

Patterns and templates for building webhook-driven bidirectional sync pipelines between Google Calendar and Planning Center Online Calendar, running on AWS Lambda.

## Use When

- Setting up webhook receivers for Google Calendar push notifications
- Setting up webhook receivers for PCO Calendar events
- Building bidirectional sync between two calendar systems
- Creating field mapping and data transformation between API formats
- Implementing idempotent webhook processing
- Managing sync state (ID mappings, sync tokens, channel tracking)

## What It Does

Provides tested patterns for:
1. Webhook handler Lambdas for Google Calendar and PCO
2. Signature verification for both webhook sources
3. Canonical type definitions for calendar events
4. Field mapping between Google and PCO formats
5. Sync orchestration with conflict resolution
6. DynamoDB sync state management
7. Terraform for the full webhook sync infrastructure

## Steps

1. Define canonical CalendarEvent type
2. Create Google Calendar webhook handler
3. Create PCO Calendar webhook handler
4. Build field mappers (Google ↔ canonical ↔ PCO)
5. Implement sync service with conflict resolution
6. Set up DynamoDB tables for sync state and idempotency
7. Create Terraform for API Gateway, Lambdas, DynamoDB, IAM
8. Set up Google Calendar push notification channel management
9. Set up PCO webhook subscriptions
10. Add tests for mapping, sync logic, and handlers

## Templates

### Google Calendar Webhook Handler (TypeScript)
Located in `templates/google-webhook-handler-ts.template`

### PCO Webhook Handler (TypeScript)
Located in `templates/pco-webhook-handler-ts.template`

### Canonical Calendar Types (TypeScript)
Located in `templates/calendar-types-ts.template`

### Sync Service (TypeScript)
Located in `templates/sync-service-ts.template`

### Terraform Webhook Infrastructure
Located in `templates/terraform-webhook-infra.template`

## Architecture

```
┌─────────────────┐     POST /google-webhook     ┌───────────────────────┐
│ Google Calendar  │ ───────────────────────────→  │ API Gateway           │
│ Push Notify      │                               │                       │
└─────────────────┘                               │  /google-webhook ──→ Lambda (google-webhook-handler)
                                                   │  /pco-webhook    ──→ Lambda (pco-webhook-handler)
┌─────────────────┐     POST /pco-webhook         │                       │
│ PCO Calendar     │ ───────────────────────────→  └───────────────────────┘
│ Webhooks         │                                          │
└─────────────────┘                                          ▼
                                                   ┌───────────────────────┐
                                                   │ Sync Service          │
                                                   │  - Verify signature   │
                                                   │  - Check idempotency  │
                                                   │  - Map fields         │
                                                   │  - Resolve conflicts  │
                                                   │  - Push to target API │
                                                   └───────────┬───────────┘
                                                               │
                                                   ┌───────────▼───────────┐
                                                   │ DynamoDB              │
                                                   │  - ID mappings        │
                                                   │  - Processed events   │
                                                   │  - Channel tracking   │
                                                   └───────────────────────┘
```

## Google Calendar Push Notifications

### Setup Flow
1. Call `calendar.events.watch()` to create a notification channel
2. Store `channelId`, `resourceId`, `expiration` in DynamoDB
3. Google sends a `sync` notification — respond 200 (no data yet)
4. On `exists` notifications, call `events.list` with stored `syncToken` to get changes
5. Process incremental changes, update `syncToken`
6. Set up a scheduled Lambda to renew channels before expiration

### Key Headers
- `X-Goog-Channel-ID` — your channel identifier
- `X-Goog-Resource-ID` — Google's resource identifier
- `X-Goog-Resource-State` — `sync`, `exists`, or `not_exists`
- `X-Goog-Channel-Token` — your verification token (set during watch)
- `X-Goog-Message-Number` — incrementing message counter

## PCO Calendar Webhooks

### Setup Flow
1. Create a webhook subscription via PCO API: `POST /webhooks`
2. Specify event types: `calendar.event.created`, `calendar.event.updated`, `calendar.event.destroyed`
3. PCO sends a test delivery — respond 200
4. On event delivery, verify HMAC-SHA256 signature, extract resource from JSON:API payload

### Verification
```
expected = HMAC-SHA256(shared_secret, raw_request_body)
actual = request.headers['X-PCO-Webhooks-Authenticity']
compare using timing-safe equality
```

## Best Practices

- Respond to webhooks quickly (200 status) — process asynchronously via SQS if sync takes > 5s
- Track all sync operations with structured logging (source, action, IDs, direction)
- Use DynamoDB TTL to auto-clean processed event records (24h retention)
- Renew Google Calendar channels proactively (before expiration)
- Handle PCO webhook retries gracefully via idempotency checks
- Test with recorded webhook payloads, not live systems
- Design for out-of-order delivery — never assume webhooks arrive in sequence

## DynamoDB Schema

### Sync Mappings Table

```
Table: {project}-sync-mappings-{env}
  PK: googleEventId (S)
  GSI: pcoEventId (S) → pco-event-index
  Attributes:
    googleUpdatedAt: ISO timestamp
    pcoUpdatedAt: ISO timestamp
    lastSyncedAt: ISO timestamp
    lastSyncDirection: "google_to_pco" | "pco_to_google"
```

### Processed Events Table

```
Table: {project}-processed-events-{env}
  PK: deliveryId (S)
  Attributes:
    ttl: epoch + 24h (auto-cleanup)
```
