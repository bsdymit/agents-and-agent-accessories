---
name: google-api-client
description: "Use when: need to generate a Google API client for Sheets, Calendar, Drive, Admin, or Gmail; creates authenticated client code"
params:
  - name: api
    description: "Google API name (sheets, calendar, drive, admin, gmail)"
  - name: operations
    description: "What operations to support (e.g., read/write sheets, create events)"
  - name: language
    description: "TypeScript or Python"
  - name: auth
    description: "Auth method (service-account, oauth2, domain-delegation)"
---

# Google API Client Generator

Generate authenticated Google API client code for use in AWS Lambda.

## Input Parameters

- **api**: Which Google API (sheets, calendar, drive, admin, gmail)
- **operations**: Specific operations needed
- **language**: TypeScript or Python
- **auth**: Authentication method

## What It Does

Generates a Google API client module including:
- Service account or OAuth2 authentication
- Credential loading from AWS SSM Parameter Store
- Credential caching for Lambda execution context reuse
- Typed helper functions for requested operations
- Error handling

## Auth Methods

- **service-account**: Most common for Lambda. Service account JSON stored in SSM.
- **domain-delegation**: Service account impersonating a user (needed for Gmail, Admin SDK).
- **oauth2**: User-delegated access. Requires token refresh handling.

## Tips

- Use the narrowest scope possible
- For Sheets, prefer `spreadsheets.readonly` if you only read
- Admin SDK and Gmail require domain-wide delegation
- Cache the auth client at module level, not inside the handler
