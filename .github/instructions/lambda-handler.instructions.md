---
name: lambda-handler
description: "Use when: editing Lambda handler files; apply Lambda best practices for handlers"
applyTo: "**/handlers/**/*.{ts,js,py}"
---

# Lambda Handler Instructions

Guidance for Lambda handler entry point files.

## Apply To

- Files matching: `**/handlers/**/*.{ts,js,py}`
- When: Creating or editing Lambda handler functions

## Guidance

### Structure
- Keep handlers thin — delegate to service modules
- Handler should only: parse event, call service, format response
- One handler per file, one Lambda function per handler

### Error Handling
- Catch all exceptions in the handler — never let unhandled errors escape
- Return proper HTTP status codes for API Gateway triggers
- Log errors with structured logging before returning error response
- For SQS triggers: throw errors to let the message retry, or catch and send to DLQ

### TypeScript Conventions
- Type the event parameter with `@types/aws-lambda` types
- Use `async/await` — never callbacks
- Export a named `handler` function (not default export)
- Use `@aws-lambda-powertools/logger` for logging

### Python Conventions
- Type hint `event: dict` and `context: LambdaContext`
- Use `@logger.inject_lambda_context` decorator
- Use `aws-lambda-powertools` for logging

### Environment Variables
- Access config via `process.env` / `os.environ`
- Never hardcode secrets, API keys, or endpoint URLs
- Use descriptive names: `PCO_APP_ID_PARAM`, `GOOGLE_SA_PARAM`, `SPREADSHEET_ID`

### Logging
- Log at handler entry: event metadata (not full event body)
- Log at handler exit: success/failure, duration
- Never log: tokens, passwords, PII, full request/response bodies in production
