---
name: prototype-summary
description: Output format for prototype generation completion summary
---

When reporting prototype generation results, use this format:

## Generation Complete

```
╔══════════════════════════════════════════════════╗
║  ProtoForge — Prototype Generated Successfully   ║
╚══════════════════════════════════════════════════╝

📋 Project:  {projectName}
📝 Description: {description}

🗄️ Entities ({entityCount}):
{for each entity}
   • {EntityName} — {fieldCount} fields
{end for}

📄 Pages ({pageCount}):
{for each page}
   • {pageName} ({pageType}) → /{route}
{end for}

📁 Location: ./{projectName}/
🚀 Start:    cd {projectName} && npm install && npm run dev
🌐 Open:     http://localhost:3000

{if deployed to github}
📂 GitHub:   https://github.com/{org}/{projectName}
📋 Clone:    git clone https://github.com/{org}/{projectName}.git
{end if}

{if deployed to cloudflare}
🌐 Preview:  https://{projectName}.pages.dev
{end if}
```

## Generation Progress (during generation)

Use this format for step-by-step progress:

```
⬜ Step 1/6: Create project scaffold
⬜ Step 2/6: Configure layout and theme
⬜ Step 3/6: Generate type definitions
⬜ Step 4/6: Generate mock data hooks
⬜ Step 5/6: Generate pages
⬜ Step 6/6: Verify build
```

Update each step as it completes:
- ⬜ → ⏳ (in progress)
- ⏳ → ✅ (completed)
- ⏳ → ❌ (failed — include error message)
