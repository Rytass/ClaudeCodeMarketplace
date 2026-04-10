---
name: proto-deploy
description: "Deploy a generated prototype to GitHub and/or Cloudflare Pages. Use when user says deploy prototype, push prototype, publish prototype, or /proto-deploy."
argument-hint: "[--dir=<path>] [--github=<org>] [--cloudflare] [--name=<project-name>]"
---

# Deploy Prototype

Deploy an existing generated prototype to GitHub and/or Cloudflare Pages.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- `--dir=<path>`: Path to the prototype directory
- `--github=<org>`: Push to this GitHub organization
- `--cloudflare`: Deploy to Cloudflare Pages
- `--name=<name>`: Override the project name for deployment
{{/if}}

## Guided Workflow

### Step 1: Locate Prototype

**If no `--dir` specified**, look for recently generated prototypes:
- Check current directory for `package.json` with mezzanine-ui dependencies
- Ask the user which prototype to deploy

### Step 2: Choose Deployment Target

**If no deployment flags specified**, ask:

> 要部署到哪裡？
>
> 1. 推送到 GitHub 組織
> 2. 部署到 Cloudflare Pages
> 3. 以上都要

### Step 3: Collect Details

**If deploying to GitHub**, ask for:
- GitHub organization name (if not provided via `--github`)

**Project name** defaults to the directory name, overridable via `--name`.

### Step 4: Confirmation

```
部署設定:
  專案:     {projectName}
  來源:     {projectDir}
  GitHub:   {orgName}/{projectName} (private)
  CF Pages: {projectName}.pages.dev

確認部署？
```

### Step 5: Launch Agent

Launch the `prototype-deployer` agent with:
- **projectDir**: Absolute path to the prototype
- **projectName**: Project name
- **deploy**: `github` | `cloudflare` | `both`
- **githubOrg**: Organization name (if applicable)

## Example Usage

```
/proto-deploy
/proto-deploy --dir=./warehouse-admin --github=my-org
/proto-deploy --dir=./warehouse-admin --cloudflare
/proto-deploy --dir=./warehouse-admin --github=my-org --cloudflare
```
