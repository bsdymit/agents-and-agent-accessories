---
name: api-integration
description: "Use when: building REST API clients, integrating with Google APIs or Planning Center Online, handling OAuth2, pagination, rate limiting; helps with reliable API integration patterns"
---

# API Integration Skill

Patterns and templates for building reliable REST API integrations with Google Workspace and Planning Center Online, running in AWS Lambda.

## Use When

- Building a client for Google APIs (Sheets, Calendar, Drive, Admin, Gmail)
- Building a client for Planning Center Online API
- Implementing OAuth2 or service account authentication
- Handling pagination for large data sets
- Implementing rate limiting and retry logic

## What It Does

Provides tested patterns for:
1. Authenticated API clients (Google service accounts, PCO tokens)
2. Pagination helpers that work within Lambda time limits
3. Rate-limited request queues
4. Data transformation between API formats

## Steps

1. Identify which API(s) the integration needs
2. Set up authentication (service account or token)
3. Create a typed API client with error handling
4. Add pagination support for list endpoints
5. Implement rate limiting / retry logic
6. Add integration tests with recorded responses

## Templates

### Google API Client (TypeScript)
Located in `templates/google-client-ts.template`

### Google API Client (Python)
Located in `templates/google-client-py.template`

### PCO API Client (TypeScript)
Located in `templates/pco-client-ts.template`

### PCO API Client (Python)
Located in `templates/pco-client-py.template`

## API Quick Reference

### Planning Center Online Products
| Product | Base Path | Common Use |
|---------|-----------|------------|
| People | `/people/v2` | Contact info, lists, field data |
| Services | `/services/v2` | Service planning, teams, songs |
| Check-Ins | `/check-ins/v2` | Attendance tracking |
| Giving | `/giving/v2` | Donations, donors |
| Groups | `/groups/v2` | Small groups, memberships |
| Calendar | `/calendar/v2` | Events, resources, rooms |
| Publishing | `/publishing/v2` | Church center content |

### Google Workspace APIs
| API | Package | Common Use |
|-----|---------|------------|
| Sheets | `googleapis` / `google-api-python-client` | Read/write spreadsheet data |
| Calendar | `googleapis` / `google-api-python-client` | Events, availability |
| Drive | `googleapis` / `google-api-python-client` | File management |
| Admin SDK | `googleapis` / `google-api-python-client` | User/group management |
| Gmail | `googleapis` / `google-api-python-client` | Send/read email |

## Best Practices

- Never store credentials in code — use SSM Parameter Store
- Always handle pagination — never assume single-page responses
- Implement exponential backoff for rate limits
- Log API calls at info level, responses at debug level
- Use TypeScript interfaces / Python TypedDicts for API response shapes
- Cache credentials in the Lambda execution context (outside handler)
- Set reasonable timeouts on HTTP requests (10-15s per call)

## Common Issues

**Q: Google API returns 403 Forbidden?**
A: Check that the service account has been granted access to the resource (e.g., shared the Sheet with the service account email). For Admin SDK, ensure domain-wide delegation is configured.

**Q: PCO returns 429 Too Many Requests?**
A: PCO allows 100 requests per 20 seconds. Implement a request queue with delays, or use `per_page=100` and `include` to reduce request count.

**Q: Lambda times out during pagination?**
A: Use `per_page=100` (PCO max), process in batches, or split work across multiple invocations via SQS.

For webhook integration patterns (Google push notifications, PCO webhook subscriptions), see the `webhook-sync` skill.
