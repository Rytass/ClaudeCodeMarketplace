---
name: scaffold-project
description: "Interactively guide new project initialization and launch the initializer agent. Use when starting a new project, setting up a repo, or bootstrapping a codebase. Trigger when user says scaffold project, init project, create project, new project, start project, bootstrap."
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
