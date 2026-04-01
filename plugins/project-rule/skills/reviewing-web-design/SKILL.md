---
name: reviewing-web-design
description: Review UI code for Vercel Web Interface Guidelines compliance. Fetches latest rules and audits *.tsx, *.css, *.scss files for semantic HTML, accessibility (ARIA, focus, keyboard navigation), layout, responsive design, and UX patterns. Use when reviewing UI components, checking accessibility, auditing frontend design, or comparing against best practices. Trigger words — review UI, check accessibility, audit design, review UX, a11y check, WCAG, UI audit, design review.
argument-hint: "<file-or-pattern>"
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Fetch the latest guidelines from the source URL below
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in the terse `file:line` format

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

Use WebFetch to retrieve the latest rules. The fetched content contains all the rules and output format instructions.

## Usage

When a user provides a file or pattern argument:
1. Fetch guidelines from the source URL above
2. Read the specified files
3. Apply all rules from the fetched guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.
