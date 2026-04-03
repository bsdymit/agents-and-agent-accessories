---
name: sync-service
description: "Use when: editing sync service or data transformation files; apply bidirectional sync and conflict resolution best practices"
applyTo: "**/services/**/*sync*.*,**/services/**/*transform*.*,**/services/**/*map*.*"
---

# Sync Service Instructions

Guidance for service modules that handle bidirectional data synchronization.

## Guidance

### Architecture

- Sync services should be pure business logic — no direct HTTP calls or AWS SDK usage
- Accept canonical types as input, return sync operations as output
- Inject API clients as dependencies for testability
- Keep field mapping separate from sync orchestration

### Canonical Types

- Define a canonical `CalendarEvent` type independent of both Google and PCO formats
- All sync logic operates on canonical types — never on raw API response shapes
- Create dedicated mapper functions: `googleEventToCanonical()`, `pcoEventToCanonical()`, `canonicalToGoogleEvent()`, `canonicalToPcoEvent()`

### Conflict Resolution

- Make the resolution strategy configurable, not hardcoded
- Always log conflict decisions at info level with both values and the winner

### Handling Deletes

- Soft-delete: mark as deleted in sync state, only hard-delete from target after confirmation
- Verify the delete is genuine (not a permission change or transient API error)
- Log all delete operations prominently — they're hard to reverse

### Testing — TDD Priority

- **Write tests before implementation** — sync services are pure logic with no I/O, ideal for TDD
- Start with field mapping tests (fixtures in, canonical types out), then implement the mapper
- Next write conflict resolution tests with deterministic timestamps, then implement the resolver
- Include round-trip tests: canonical → API format → canonical should be lossless
- Mock the sync state store and API clients, not the sync logic itself
