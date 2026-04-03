---
name: pco-endpoint
description: "Use when: need to add a Planning Center Online API endpoint integration; generates typed client code for a PCO endpoint"
params:
  - name: product
    description: "PCO product name (people, services, check-ins, giving, groups, calendar)"
  - name: resource
    description: "Resource name (e.g., people, service_types, donations, events)"
  - name: operations
    description: "Which operations to generate (list, get, create, update, delete)"
  - name: language
    description: "TypeScript or Python"
---

# PCO Endpoint Client

Generate typed client code for a specific Planning Center Online API endpoint.

## Input Parameters

- **product**: PCO product (people, services, check-ins, giving, groups, calendar)
- **resource**: API resource name
- **operations**: CRUD operations needed
- **language**: TypeScript or Python

## What It Does

Generates client functions for the specified PCO endpoint including:
- Typed request/response interfaces (TS) or TypedDicts (Python)
- List with pagination support
- Get by ID
- Create / Update / Delete as requested
- Error handling with meaningful messages

## Tips

- PCO uses JSON:API format — resources have `type`, `id`, `attributes`, `relationships`
- Use `include` query param to sideload related resources and reduce requests
- Use `where[field]=value` for server-side filtering
- Max `per_page` is 100
