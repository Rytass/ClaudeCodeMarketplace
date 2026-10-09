---
name: scaffold-project
description: "Interactive entry point that initializes an empty NestJS + Next.js repo with project-rule conventions. Asks for project name and topology (Nx monorepo or standalone), then launches the project-initializer agent to set up ESLint, Prettier, commitlint, Husky, TypeORM, MemberBaseModule + Casbin, GraphQL code-first, Docker and CI. Use only when the user explicitly wants this plugin to scaffold a repo's code and toolchain. Trigger words — scaffold project, /scaffold-project, 用 project-rule 初始化 repo. For topology advice or fixing lint, commitlint or Docker config, use initializing-project."
argument-hint: "[--topology=monorepo|standalone]"
---

# Initialize Project

Follow the workflow below to guide the user through new project initialization.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- If `--topology=monorepo` is present, use the Nx Monorepo topology directly
- If `--topology=standalone` is present, use the Standalone topology directly
- Treat remaining text as the project name
{{/if}}

## Guided Workflow

1. **If no project name is provided**, ask the user for:
   - Project name (used for the directory name and `package.json` `name` field)

2. **If no topology is specified**, ask the user to choose:
   - **Nx Monorepo**: Frontend and backend in the same repo; suitable for medium-to-large projects that need shared types and modules
   - **Standalone**: Frontend and backend in separate repos; suitable for small projects with independent deployment

3. Once all information is collected, launch the `project-initializer` agent to execute initialization.

## Example Usage

```
/scaffold-project
/scaffold-project my-project
/scaffold-project --topology=monorepo
/scaffold-project my-project --topology=standalone
```
