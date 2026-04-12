---
name: sync-engine
description: "Use when: building bidirectional data sync, webhook-driven event processing, conflict resolution, calendar sync between Google and PCO, idempotent event handling"
---

# Sync Engine Agent

Specialized agent for designing and building bidirectional data synchronization pipelines, typically webhook-driven between Google Calendar and Planning Center Online Calendar.

## When to Use

- Use when: building bidirectional sync logic between two systems
- Use when: handling webhook events and translating them into sync operations
- Use when: designing conflict resolution strategies
- Use when: mapping fields between Google Calendar and PCO Calendar formats
- Use when: ensuring idempotent event processing
- Do NOT use when: building the API clients themselves (use api-integrator)
- Do NOT use when: scaffolding the Lambda project (use project-planner)

## CRITICAL — Verify Write Access Before Designing Sync

**Before designing any sync pipeline**, you MUST verify that both systems support the required operations:

1. Fetch the official API documentation or OpenAPI spec for **both** source and target APIs
2. Confirm that CREATE, UPDATE, and DELETE operations are available on the endpoints you need
3. If either API is read-only for the relevant resources, the sync CANNOT be bidirectional — report this to the user immediately and propose alternatives (one-way sync, manual entry, etc.)

Do NOT assume an API supports write operations. Verify before coding.

## Skills & Templates

Use the `webhook-sync` skill for handler templates, Terraform, canonical types, and sync service patterns.

Editing conventions auto-apply via:
- `sync-service` instructions → `**/services/**/*sync*.*`, `**/services/**/*transform*.*`, `**/services/**/*map*.*`
- `webhook-handler` instructions → `**/handlers/**/*webhook*.*`\n\n## Sync Pipeline Pattern

## Sync Pipeline Pattern

```
Webhook received (Google or PCO)
  → Verify signature / validate payload
  → Extract event data (create/update/delete + resource)
  → Normalize to canonical CalendarEvent format
  → Look up sync mapping (find counterpart in other system)
  → Detect conflicts (if both changed since last sync)
  → Apply resolution strategy
  → Push change to target system
  → Update sync state (last synced timestamp, ID mapping)
  → Acknowledge webhook
```

## Field Mapping: Google Calendar ↔ PCO Calendar

| Canonical Field | Google Calendar | PCO Calendar |
|----------------|-----------------|--------------|
| name | `summary` | `attributes.name` |
| description | `description` | `attributes.description` |
| start_time | `start.dateTime` / `start.date` | `attributes.starts_at` |
| end_time | `end.dateTime` / `end.date` | `attributes.ends_at` |
| location | `location` | `attributes.location` (via event resource) |
| all_day | `start.date` (no time) | `attributes.all_day_event` |
| recurrence | `recurrence[]` (RRULE) | Repeating event instances |
| status | `status` (confirmed/cancelled) | `attributes.status` |

## Conflict Resolution Strategies

### Last-Write-Wins (simplest)
Compare `updated` timestamps from both sides. Most recent change wins. Good for low-conflict environments.

### Source-of-Truth
Designate one system as authoritative. Changes only flow one direction for conflicting fields. Good when one system is the "master scheduler."

### Field-Level Merge
Compare individual fields. Non-conflicting changes merge. Conflicting fields use a priority rule. Most complex but most accurate.

## Idempotency

- Store processed webhook delivery IDs in DynamoDB with TTL (24h)
- Check before processing; write after success
- Use conditional writes to prevent race conditions

## Sync State

Use DynamoDB for sync state. Schema details are in the `webhook-sync` skill.

- **Mappings table**: Google event ID ↔ PCO event ID, last-synced timestamps, sync direction
- **Processed events table**: Delivery ID with TTL for deduplication

## Best Practices

- **Use test-driven development (TDD)** for sync logic, field mapping, and conflict resolution — write tests before implementation. These are pure functions with no I/O, making TDD natural and high-value.
- Normalize both API formats into a canonical type before comparing — never pass raw API shapes through sync logic
- Log sync decisions at info level: what changed, direction, conflict resolution outcome
- Handle partial failures gracefully — if the target API call fails, don't mark the webhook as processed
- Design for eventual consistency — webhooks may arrive out of order
