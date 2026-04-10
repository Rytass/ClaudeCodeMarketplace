---
name: analyze-document
description: "Analyze RFP, project spec, or planning document and extract a structured ProjectSpec for prototype generation. Use when user provides a document to analyze, wants to extract requirements from a spec, or needs to convert planning documents into structured prototype specs. Trigger on analyze document, parse RFP, extract requirements, read spec."
---

# Analyze Document for Prototype Generation

Read a project planning document (RFP, project specification, requirement document) and extract a structured `ProjectSpec` for use with the `prototype-generator` agent.

## Input

The user provides one of:
- **PDF file path** — Read via the Read tool (supports PDF)
- **DOCX/MD file path** — Read directly
- **Pasted text** — Provided inline in the conversation

## Extraction Workflow

### Step 1: Read the Document

Read the entire document content. For large PDFs, read in page ranges.

### Step 2: Identify Entities

Scan for **nouns that represent data objects** the system manages:
- Look for section headings like "功能需求", "系統模組", "資料管理"
- Look for database/data model descriptions
- Look for screen/page descriptions mentioning data lists or forms
- Common patterns: "XX管理", "XX列表", "XX報表"

For each entity, extract:
- **Name**: PascalCase (e.g., "PurchaseOrder" from "採購單管理")
- **Fields**: All attributes mentioned (name, type, whether shown in table/form/filter)

### Step 3: Determine Field Types

Map document descriptions to field types:

| Document Clue | Field Type |
|---------------|-----------|
| "名稱", "標題", "代碼", "編號" | `string` |
| "說明", "備註", "描述" | `text` |
| "數量", "金額", "單價", "百分比" | `number` |
| "日期", "建立時間" | `date` |
| "日期時間", "時間戳記" | `datetime` |
| "是否", "啟用", "有效" | `boolean` |
| "狀態", "類別", "等級" (with finite options) | `enum` |
| "所屬XX", "關聯XX", referencing another entity | `select` |

### Step 4: Plan Pages

For each entity, determine what pages are needed:
- **Most entities** → `list` page (table with CRUD)
- **Complex entities** with many relations → `list` + `detail` page
- **If document mentions "儀表板" or "總覽"** → `dashboard` page
- **Very complex forms** (many fields, steps) → separate `form` page instead of modal

### Step 5: Design Navigation

Group pages into a sidebar navigation structure:
- Group by domain (e.g., "主資料", "營運管理", "報表", "系統設定")
- Choose icons from @mezzanine-ui/icons that match the domain semantics
- Order from most-used to least-used

### Step 6: Output ProjectSpec

Output the complete ProjectSpec as a JSON code block following the format in the `protoforge` skill's `references/PROJECT_SPEC.md`.

### Step 7: Present Summary

Present a human-readable summary for the user to confirm:

```
📋 專案: {projectName}
📝 描述: {description}

🗄️ 實體 ({count}):
  - {EntityName} ({fieldCount} 欄位)
  - ...

📄 頁面 ({count}):
  - {pageName} ({pageType}) → /{route}
  - ...

📁 導航:
  {NavGroup1}
    ├── {Page1}
    └── {Page2}
  {NavGroup2}
    └── {Page3}
```

Ask the user: "這個規格是否正確？有需要調整的地方嗎？"

## Common Icons (for navigation)

| Domain           | Icon (from `@mezzanine-ui/icons`)       |
|------------------|-----------------------------------------|
| 主資料/基礎資料   | `FolderIcon`                            |
| 商品/產品         | `BoxIcon`                               |
| 人員/會員/客戶    | `UserIcon`                              |
| 訂單/交易         | `FileIcon`                              |
| 倉庫/物流         | `FolderMoveIcon`                        |
| 財務/帳務         | `CurrencyDollarIcon`                    |
| 報表/統計         | `ListIcon`                              |
| 系統設定          | `SettingIcon`                           |
| 儀表板/總覽       | `HomeIcon` / `DotGridIcon`              |
| 通知/訊息         | `NotificationIcon` / `MailIcon`         |

## Edge Cases

- **Document too vague**: If entities/fields cannot be confidently extracted, ask the user for clarification
- **Too many entities**: For large systems (10+ entities), suggest prioritizing the top 5-8 for the prototype
- **No clear entities**: If the document is purely conceptual (no data structure), guide the user to describe entities interactively
- **Mixed languages**: Entity names should be PascalCase English; labels should be Traditional Chinese
