---
name: reviewing-web-design
description: "Audits React and Next.js UI code (*.tsx, *.css, *.scss) against the latest Vercel Web Interface Guidelines — semantic HTML, accessibility (ARIA, labels, focus states, keyboard navigation), layout, responsive behaviour and UX details — and reports findings as file:line. Use when reviewing a page or component before merge, or when the user asks about a11y, keyboard support or UI quality. Trigger words — review UI, a11y, WCAG, 無障礙, 無障礙檢查, 鍵盤操作, focus 樣式, UI 審查, 前端 code review. For NestJS architecture audits, use /audit-patterns."
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
