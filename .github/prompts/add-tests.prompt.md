---
name: add-tests
description: "Use when: need to add unit tests for a Lambda handler or API client; generates Jest or pytest tests"
params:
  - name: file
    description: "Path to the source file to test"
  - name: framework
    description: "Test framework (jest for TS, pytest for Python)"
---

# Add Tests

Generate unit tests for a Lambda handler or API client module.

## Input Parameters

- **file**: The source file to write tests for
- **framework**: jest (TypeScript) or pytest (Python)

## What It Does

1. Reads the source file to understand exports and dependencies
2. Creates a test file in the corresponding `tests/unit/` directory
3. Mocks external dependencies (AWS SDK, API clients, fetch)
4. Generates test cases for:
   - Happy path (successful execution)
   - Error handling (API errors, timeouts)
   - Edge cases (empty data, missing fields)
   - Input validation

## Test Conventions

### TypeScript (Jest)
- Test files: `tests/unit/{module}.test.ts`
- Mock AWS SDK with `jest.mock('@aws-sdk/...')`
- Mock fetch with `jest.fn()` or `jest-fetch-mock`
- Use `describe` / `it` blocks

### Python (pytest)
- Test files: `tests/unit/test_{module}.py`
- Mock with `unittest.mock.patch`
- Use fixtures for common setup
- Use `pytest.raises` for error cases

## Tips

- Mock at the HTTP/SDK boundary, not at your function level
- Include a test for the rate-limit retry path
- Test with realistic but minimal sample data
- Don't test framework/library behavior — test your logic
