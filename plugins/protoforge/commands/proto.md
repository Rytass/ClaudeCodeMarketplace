---
name: proto
description: "Interactively generate an admin prototype from a project planning document. Use when user says /proto, generate prototype, create admin prototype, build prototype from document, or wants to turn an RFP/spec into a working admin UI."
argument-hint: "[--doc=<path>] [--name=<project-name>]"
---

# ProtoForge — Interactive Prototype Generation

Guide the user through generating an admin prototype from a project planning document.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- If `--doc=<path>` is present, use that file as the input document
- If `--name=<name>` is present, use that as the project name
- Treat remaining text as additional context or project description
{{/if}}

## Guided Workflow

### Step 1: Document Input

**If no document is specified**, ask the user:

> 請提供專案規劃文件（支援 PDF、DOCX、Markdown 或直接貼上文字）：
>
> 1. 提供檔案路徑（例如 `./docs/rfp.pdf`）
> 2. 直接在這裡描述你的系統需求

### Step 2: Analyze Document

Use the `analyze-document` skill to:
1. Read and parse the document
2. Extract entities, fields, pages, and navigation
3. Generate a `ProjectSpec`

### Step 3: Present Spec Summary

Display the extracted specification in a clear summary format:

```
📋 專案: {projectName}
📝 描述: {description}

🗄️ 實體 ({count}):
  - {EntityName}: {field1}, {field2}, ... ({fieldCount} 欄位)

📄 頁面 ({count}):
  - {pageName} (列表頁) → /{route} [新增/編輯/刪除]
  - {pageName} (儀表板) → /dashboard

📁 導航結構:
  {Group}
    ├── {Page1}
    └── {Page2}
```

### Step 4: Project Name

**If no project name is specified**, ask:

> 請為這個原型專案取一個名稱（kebab-case，例如 `warehouse-admin`）：

The name will be used as:
- Directory name
- `package.json` name
- GitHub repo name (if deploying)
- Cloudflare Pages project name (if deploying)

### Step 5: User Confirmation

Ask the user to confirm or adjust:

> 以上規格是否正確？
>
> - ✅ 確認，開始生成
> - ✏️ 我想調整（請說明要修改的部分）

If the user wants to adjust, modify the ProjectSpec accordingly and re-display.

### Step 6: Deployment Options (Optional)

Ask about optional deployment:

> 生成完成後，是否需要部署？（預設僅本地生成）
>
> 1. 僅本地生成（預設）
> 2. 推送到 GitHub 組織（需提供組織名稱）
> 3. 部署到 Cloudflare Pages
> 4. 以上都要

If the user chooses GitHub, ask for the organization name.

### Step 7: Launch Agent

Once confirmed, launch the `prototype-generator` agent with:

- **projectSpec**: The confirmed ProjectSpec JSON
- **projectName**: The chosen project name

If deployment is requested, launch the `prototype-deployer` agent **after generation completes** with:

- **projectDir**: Absolute path to the generated prototype directory
- **projectName**: The chosen project name
- **deploy**: `github` | `cloudflare` | `both`
- **githubOrg**: GitHub organization name (if applicable)
- **repoVisibility**: `public` or `private` (default: `private`)

## Example Usage

```
/proto
/proto --doc=./rfp.pdf
/proto --name=warehouse-admin --doc=./docs/spec.md
/proto --name=my-crm
```

## Quick Mode

If the user provides both `--doc` and `--name`, skip Steps 1 and 4 and go straight to analysis and confirmation.
