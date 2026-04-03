---
name: api-client
description: "Use when: editing API client files for Google or PCO integrations; apply API client best practices"
applyTo: "**/clients/**/*.{ts,js,py}"
---

# API Client Instructions

Guidance for API client modules that interact with Google APIs or Planning Center Online.

## Guidance

### Authentication
- Cache auth objects outside the handler (module-level) for Lambda execution context reuse
- Load credentials from SSM Parameter Store or Secrets Manager, never from code
- Use service accounts for Google server-to-server auth
- Use Personal Access Tokens for PCO in Lambda contexts

### HTTP Best Practices
- Set explicit timeouts on all HTTP requests (10-15 seconds)
- Handle rate limiting with exponential backoff
- Always check response status before parsing body
- Use session/connection reuse for multiple requests (Python `requests.Session`, Node `fetch` with keep-alive)

### Pagination
- Always paginate — never assume a single page
- Use `per_page=100` for PCO (the max)
- Use `pageSize` for Google APIs
- Accumulate results in an array, return the full list

### Error Handling
- Wrap API errors with context (endpoint, status code, relevant IDs)
- Distinguish retryable errors (429, 500, 503) from permanent errors (400, 401, 404)
- Log failed requests at error level with the endpoint and status

### Data Transformation
- Transform API responses at the client boundary — return clean typed objects
- Don't leak JSON:API envelope structure (PCO) into business logic
- Map field names to your domain language

### Testing
- Create integration tests with recorded API responses
- Mock the HTTP layer, not the client methods
- Test pagination handling with multi-page response fixtures
