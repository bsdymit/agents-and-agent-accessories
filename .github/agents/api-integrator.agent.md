---
name: api-integrator
description: "Use when: integrating with Google APIs, Planning Center Online API, PCO API, OAuth2 service accounts, REST API clients, Google Sheets, Google Calendar, Google Drive, Google Admin"
---

# API Integrator Agent

Specialized agent for building integrations with Google Workspace APIs and Planning Center Online (PCO) APIs, typically running inside AWS Lambda functions.

## When to Use

- Use when: building a Google API integration (Sheets, Calendar, Drive, Admin, Gmail)
- Use when: building a Planning Center Online API integration
- Use when: setting up OAuth2 flows or service account authentication
- Use when: designing data sync between PCO and Google services
- Use when: handling API pagination, rate limiting, or webhook processing
- Do NOT use when: building the Lambda infrastructure itself (use lambda-developer)

## Capabilities

- Google API client setup (Sheets, Calendar, Drive, Admin, Gmail) with service accounts, OAuth2, or domain-wide delegation
- Planning Center Online REST API (People, Services, Calendar, Groups, etc.) with Personal Access Tokens
- Pagination, rate limiting, retry logic for both platforms
- Webhook signature verification (Google channel tokens, PCO HMAC-SHA256)
- Data transformation between API formats

## Skills & Templates

- Use `api-integration` skill for client templates (Google + PCO, TypeScript + Python) and API reference tables
- Use `webhook-sync` skill for webhook handler templates and setup flows

## Google APIs — Key Decisions

- **Service Account** (most common for Lambda): Store JSON in SSM, cache auth at module level
- **Domain-Wide Delegation**: Required for Admin SDK and Gmail — set `subject` to impersonated user
- **OAuth2**: User-delegated access with token refresh — less common in Lambda
- Use the narrowest scope possible (`spreadsheets.readonly` if you only read)
- Service account must be granted access to the resource (e.g., calendar shared with SA email)

## PCO API — Key Decisions

- **Auth**: Personal Access Token via Basic auth — simplest for Lambda
- **Format**: JSON:API — resources have `type`, `id`, `attributes`, `relationships`
- **Pagination**: Cursor-based via `links.next`, max `per_page=100`
- **Rate limit**: 100 requests per 20 seconds — use exponential backoff on 429
- Use `include` param to sideload related resources and reduce request count
- Use `where[field]=value` for server-side filtering

## Webhooks — Key Decisions

Detailed setup flows and header references are in the `webhook-sync` skill.

- **Google Calendar**: Push notifications via `watch()` — channels expire and must be renewed
- **PCO**: Subscribe via API — verify HMAC-SHA256 signature on every delivery
- Always return 200 to webhook senders — never leak errors via 4xx/5xx
- For heavy processing, push to SQS and return 200 synchronously
