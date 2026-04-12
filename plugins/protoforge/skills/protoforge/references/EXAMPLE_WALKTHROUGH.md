# End-to-End Example Walkthrough

A complete example showing the full ProtoForge workflow — from an RFP document to a running prototype.

---

## 1. Input Document (RFP Excerpt)

The user provides the following warehouse management system RFP:

> **倉儲管理系統需求規格書**
>
> 本系統為中型物流公司設計之倉儲管理後台，主要管理以下業務：
>
> **一、商品管理**
> 管理所有進出貨商品。欄位包含：商品名稱、SKU 編號、分類（原物料/半成品/成品）、單價、庫存數量、商品圖片、是否啟用、建立日期。
> 支援列表瀏覽、新增、編輯、刪除、匯出 CSV。可依名��、分類、啟用狀態篩選。
>
> **二、倉庫管理**
> 管理公司各地倉庫。欄位包含：倉庫名稱、地址、容量上限、負責人（選擇員工）、備註。
> 支援列表瀏覽、新增、編輯。
>
> **三、員工管理**
> 管理倉���作業人員。欄位包含：姓名、Email、電話、職位（倉管/主管/司機）、擁有標籤（多選：堆高機/理貨/揀貨/包裝）、大頭照、密碼。
> 支援列表瀏覽、新增、編輯、檢視詳情。詳情頁分為「基本資訊」和「負責倉庫」兩個 Tab。
>
> **四、儀表板**
> 系統首頁顯示：商品總數、倉庫數量、員工人數、各分類商品數量分佈、最近新增商品與員工紀錄。

---

## 2. Extracted ProjectSpec

The `analyze-document` skill processes the above and produces:

```json
{
  "projectName": "warehouse-admin",
  "description": "倉儲管理系統原型",
  "entities": [
    {
      "name": "Product",
      "fields": [
        { "name": "id", "type": "string", "required": false, "isFilterable": false, "isTableColumn": false, "label": "ID" },
        { "name": "name", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "商品名稱", "validation": { "max": 100, "message": "名稱不得超過 100 字" } },
        { "name": "sku", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "SKU 編號", "validation": { "pattern": "^[A-Z0-9]{4,12}$", "message": "SKU 須為 4-12 位大寫英數字" } },
        { "name": "category", "type": "enum", "required": true, "isFilterable": true, "isTableColumn": true, "label": "分類", "enumOptions": ["原物料", "半成品", "成品"] },
        { "name": "price", "type": "number", "required": true, "isFilterable": false, "isTableColumn": true, "label": "單價", "validation": { "min": 1, "max": 999999 } },
        { "name": "quantity", "type": "number", "required": true, "isFilterable": false, "isTableColumn": true, "label": "庫存數量", "validation": { "min": 0 } },
        { "name": "image", "type": "image", "required": false, "isFilterable": false, "isTableColumn": true, "label": "商品圖片" },
        { "name": "isActive", "type": "boolean", "required": false, "isFilterable": true, "isTableColumn": true, "label": "啟用狀態" },
        { "name": "createdAt", "type": "date", "required": false, "isFilterable": true, "isTableColumn": true, "label": "建立日期" }
      ]
    },
    {
      "name": "Warehouse",
      "fields": [
        { "name": "id", "type": "string", "required": false, "isFilterable": false, "isTableColumn": false, "label": "ID" },
        { "name": "name", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "倉庫名稱" },
        { "name": "location", "type": "string", "required": true, "isFilterable": false, "isTableColumn": true, "label": "地址" },
        { "name": "capacity", "type": "number", "required": true, "isFilterable": false, "isTableColumn": true, "label": "容量上限" },
        { "name": "managerId", "type": "select", "required": true, "isFilterable": true, "isTableColumn": true, "label": "負責人", "relatedEntity": "Employee" },
        { "name": "note", "type": "text", "required": false, "isFilterable": false, "isTableColumn": false, "label": "備註" }
      ]
    },
    {
      "name": "Employee",
      "fields": [
        { "name": "id", "type": "string", "required": false, "isFilterable": false, "isTableColumn": false, "label": "ID" },
        { "name": "name", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "姓名" },
        { "name": "email", "type": "string", "required": true, "isFilterable": false, "isTableColumn": true, "label": "Email", "validation": { "pattern": "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", "message": "請輸入有效 Email" } },
        { "name": "phone", "type": "string", "required": true, "isFilterable": false, "isTableColumn": true, "label": "電話" },
        { "name": "position", "type": "enum", "required": true, "isFilterable": true, "isTableColumn": true, "label": "職位", "enumOptions": ["倉管", "主管", "司機"] },
        { "name": "skills", "type": "multiselect", "required": false, "isFilterable": true, "isTableColumn": true, "label": "標籤", "multiselectOptions": ["堆高機", "理貨", "揀貨", "包裝"] },
        { "name": "avatar", "type": "image", "required": false, "isFilterable": false, "isTableColumn": true, "label": "大頭照" },
        { "name": "password", "type": "password", "required": true, "isFilterable": false, "isTableColumn": false, "label": "密碼" }
      ]
    }
  ],
  "pages": [
    { "name": "商品管理", "route": "products", "type": "list", "entityRef": "Product", "actions": ["create", "edit", "delete", "export"] },
    { "name": "倉庫管理", "route": "warehouses", "type": "list", "entityRef": "Warehouse", "actions": ["create", "edit"] },
    { "name": "員工管理", "route": "employees", "type": "list", "entityRef": "Employee", "actions": ["create", "edit", "view"] },
    {
      "name": "員工詳情", "route": "employees", "type": "detail", "entityRef": "Employee", "actions": ["view"],
      "tabs": [
        { "label": "基本資訊", "fields": ["name", "email", "phone", "position", "skills", "avatar"] },
        { "label": "負責倉庫", "relatedEntity": "Warehouse" }
      ]
    },
    { "name": "儀表板", "route": "", "type": "dashboard", "entityRef": "Product", "actions": ["view"] }
  ],
  "navigation": [
    { "label": "儀表板", "icon": "HomeIcon", "route": "" },
    {
      "label": "主資料",
      "icon": "FolderIcon",
      "children": [
        { "label": "商品管理", "icon": "BoxIcon", "route": "products" },
        { "label": "倉庫管理", "icon": "FolderMoveIcon", "route": "warehouses" }
      ]
    },
    { "label": "員工管理", "icon": "UserIcon", "route": "employees" }
  ]
}
```

### Extraction Decisions

| RFP 描述 | 推斷結果 | 理由 |
|----------|---------|------|
| 「商品圖片」 | `type: "image"` | 明確提及圖片 |
| 「擁有標籤（多選：堆高機/理貨/揀貨/包裝）」 | `type: "multiselect"`, `multiselectOptions` | 「多選」明確指出 multiselect |
| 「大頭照」 | `type: "image"` | 人員照片 |
| 「密碼」 | `type: "password"` | 認證欄位 |
| 「負責人（選擇員工）」 | `type: "select"`, `relatedEntity: "Employee"` | 關聯另一個實體 |
| 「匯出 CSV」 | `actions: [..., "export"]` | 明確提及��出 |
| 「詳情頁分為兩個 Tab」 | `tabs: [...]` on detail page | 明確提及 tab 分組 |
| 「SKU 編號」 | `validation.pattern` | 編號格式通常有規則 |

---

## 3. Generated File Tree

```
warehouse-admin/
├── package.json
├── tsconfig.json
├── next.config.js
├── .gitignore
├── README.md
└── src/
    ├── app/
    │   ├── globals.scss
    │   ├── layout.tsx
    │   └── (admin)/
    │       ├── layout.tsx                        # AuthorizedAdminPageWrapper + navigation
    │       ├── page.tsx                          # Dashboard (儀表板)
    │       ├── products/
    │       │   ├── page.tsx                      # Product list page
    │       │   └── _components/
    │       │       └── ProductFormModal.tsx       # Create/Edit modal
    │       ├── warehouses/
    │       │   ├── page.tsx                      # Warehouse list page
    │       │   └── _components/
    │       │       └── WarehouseFormModal.tsx
    │       └── employees/
    │           ├── page.tsx                      # Employee list page
    │           ├── [id]/
    │           │   └── page.tsx                  # Employee detail (with tabs)
    │           └── _components/
    │               └── EmployeeFormModal.tsx
    ├── hooks/
    │   ├── index.ts
    │   ├── useMockEmployee.ts                    # Generated first (leaf entity)
    │   ├── useMockProduct.ts
    │   └── useMockWarehouse.ts                   # References Employee via managerId
    ├── types/
    │   └── index.ts
    └── utils/
        └── downloadCSV.ts                        # CSV export utility
```

### Entity Generation Order (topological sort)

1. **Employee** — no dependencies (leaf entity)
2. **Product** — no dependencies (leaf entity)
3. **Warehouse** — depends on Employee (`managerId` → `select` → `relatedEntity: "Employee"`)

---

## 4. Key Generated Code Samples

### `src/hooks/useMockEmployee.ts` (leaf entity — generated first)

```tsx
'use client';

import { useState, useCallback } from 'react';
import { faker } from '@faker-js/faker/locale/zh_TW';
import type { MockEmployee } from '@/types';

function hashCode(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash + str.charCodeAt(i)) | 0;
  }
  return Math.abs(hash);
}

faker.seed(hashCode('Employee'));

const positionOptions = ['倉管', '主管', '司機'] as const;
const skillOptions = ['堆高機', '理貨', '揀貨', '包裝'] as const;

function createMockEmployee(): MockEmployee {
  return {
    id: faker.string.uuid(),
    name: faker.person.fullName(),
    email: faker.internet.email(),
    phone: faker.phone.number(),
    position: faker.helpers.arrayElement(positionOptions),
    skills: faker.helpers.arrayElements([...skillOptions], { min: 1, max: 3 }),
    avatar: faker.image.url({ width: 200, height: 200 }),
    password: faker.internet.password({ length: 12 }),
  };
}

export const mockEmployeeData: readonly MockEmployee[] = Array.from(
  { length: 50 },
  createMockEmployee,
);

export function useMockEmployee(): {
  readonly items: readonly MockEmployee[];
  readonly create: (values: Omit<MockEmployee, 'id'>) => void;
  readonly update: (id: string, values: Partial<MockEmployee>) => void;
  readonly remove: (id: string) => void;
} {
  const [items, setItems] = useState<readonly MockEmployee[]>(mockEmployeeData);

  const create = useCallback((values: Omit<MockEmployee, 'id'>): void => {
    const newItem: MockEmployee = { ...values, id: faker.string.uuid() };
    setItems((prev) => [newItem, ...prev]);
  }, []);

  const update = useCallback((id: string, values: Partial<MockEmployee>): void => {
    setItems((prev) =>
      prev.map((item) => (item.id === id ? { ...item, ...values } : item)),
    );
  }, []);

  const remove = useCallback((id: string): void => {
    setItems((prev) => prev.filter((item) => item.id !== id));
  }, []);

  return { items, create, update, remove } as const;
}
```

### `src/hooks/useMockWarehouse.ts` (depends on Employee)

```tsx
'use client';

import { useState, useCallback } from 'react';
import { faker } from '@faker-js/faker/locale/zh_TW';
import { mockEmployeeData } from './useMockEmployee'; // Cross-entity reference
import type { MockWarehouse } from '@/types';

function hashCode(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash + str.charCodeAt(i)) | 0;
  }
  return Math.abs(hash);
}

faker.seed(hashCode('Warehouse'));

function createMockWarehouse(): MockWarehouse {
  return {
    id: faker.string.uuid(),
    name: `${faker.location.city()}倉庫`,
    location: faker.location.streetAddress(),
    capacity: faker.number.int({ min: 100, max: 10000 }),
    managerId: faker.helpers.arrayElement(mockEmployeeData).id, // Real Employee ID
    note: faker.lorem.sentences(2),
  };
}

export const mockWarehouseData: readonly MockWarehouse[] = Array.from(
  { length: 10 }, // Reference data — smaller count
  createMockWarehouse,
);

// ... useMockWarehouse hook (same pattern) ...
```

### `src/app/(admin)/products/page.tsx` (list page with export)

```tsx
'use client';

import { useState, useMemo, useCallback } from 'react';
import { PageWrapper, AdminTable } from 'mezzanine-ui-admin-components';
import { TableColumn } from '@mezzanine-ui/core/table';
import { Typography, Tag, Button, Icon } from '@mezzanine-ui/react';
import { DownloadIcon } from '@mezzanine-ui/icons';
import { format } from 'date-fns';
import { useMockProduct } from '@/hooks/useMockProduct';
import { downloadCSV } from '@/utils/downloadCSV';
import { ProductFormModal } from './_components/ProductFormModal';
import type { MockProduct } from '@/types';

export default function ProductListPage(): JSX.Element {
  const { items, create, update, remove } = useMockProduct();
  const [page, setPage] = useState<number>(1);
  const pageSize = 10;
  const [modalOpen, setModalOpen] = useState<boolean>(false);
  const [editingItem, setEditingItem] = useState<MockProduct | null>(null);

  // ... handlers (same as PAGE_PATTERNS template) ...

  const columns = useMemo((): TableColumn<MockProduct>[] => [
    { title: '商品名稱', dataIndex: 'name', width: 200 },
    { title: 'SKU', dataIndex: 'sku', width: 150 },
    {
      title: '分類', width: 100,
      render: (source) => <Tag label={source.category} />,
    },
    {
      title: '單價', width: 120, align: 'end' as const,
      render: (source) => <Typography variant="body">{source.price.toLocaleString()}</Typography>,
    },
    {
      title: '商品圖片', width: 80,
      render: (source) => (
        source.image
          ? <img src={source.image} alt="" style={{ width: 48, height: 48, objectFit: 'cover', borderRadius: 'var(--mzn-spacing-1)' }} />
          : <Typography color="text-neutral-light">—</Typography>
      ),
    },
    {
      title: '啟用狀態', width: 100,
      render: (source) => (
        <Tag label={source.isActive ? '啟用' : '停用'} />
      ),
    },
    {
      title: '建立日期', width: 150,
      render: (source) => format(new Date(source.createdAt), 'yyyy/MM/dd'),
    },
  ], []);

  const exportColumns = useMemo(() => [
    { title: '商品名稱', dataIndex: 'name' as const },
    { title: 'SKU', dataIndex: 'sku' as const },
    { title: '分類', dataIndex: 'category' as const },
    { title: '單價', render: (s: MockProduct) => String(s.price) },
    { title: '啟用', render: (s: MockProduct) => s.isActive ? '是' : '否' },
  ], []);

  const paginatedData = useMemo(
    () => items.slice((page - 1) * pageSize, page * pageSize),
    [items, page],
  );

  return (
    <PageWrapper
      title="商品管理"
      onCreate={() => { setEditingItem(null); setModalOpen(true); }}
      createText="新增商品"
      customizeActionComponent={
        <Button
          variant="base-secondary"
          icon={DownloadIcon}
          iconType="leading"
          onClick={() => downloadCSV(items, exportColumns, 'products')}
        >
          匯出 CSV
        </Button>
      }
    >
      <AdminTable<MockProduct>
        dataSource={paginatedData}
        columns={columns}
        pagination={{
          total: items.length,
          current: page,
          onChange: setPage,
          options: { pageSize },
        }}
        actions={(source) => [
          { text: '編輯', onClick: () => { setEditingItem(source); setModalOpen(true); } },
          { text: '刪除', danger: true, onClick: () => remove(source.id) },
        ]}
      />
      <ProductFormModal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        onSubmit={(values) => {
          if (editingItem) { update(editingItem.id, values); }
          else { create(values); }
          setModalOpen(false);
        }}
        defaultValues={editingItem}
        mode={editingItem ? 'edit' : 'create'}
      />
    </PageWrapper>
  );
}
```

---

## 5. Interactive `/proto` Session Flow

Below is a condensed transcript of the full `/proto` command interaction:

### Step 1 — User invokes command

```
User: /proto --doc=./docs/warehouse-rfp.md
```

### Step 2 — Document analysis

```
Claude: 正在分析文件 ./docs/warehouse-rfp.md ...
        已識別 3 個實體、5 個頁面。
```

### Step 3 — Spec summary for confirmation

```
Claude:
📋 專案: warehouse-admin
📝 描述: 倉儲管理系統原型

🗄️ 實體 (3):
  - Product: name, sku, category, price, quantity, image, isActive, createdAt (8 欄位)
  - Warehouse: name, location, capacity, managerId, note (5 欄位)
  - Employee: name, email, phone, position, skills, avatar, password (7 欄位)

📄 頁面 (5):
  - 商品管理 (列表頁) → /products [新增/編輯/刪除/匯出]
  - 倉庫管理 (列表頁) → /warehouses [新增/編輯]
  - 員工管理 (列表頁) → /employees [新增/編輯/檢視]
  - 員工詳情 (詳情頁) → /employees/[id] [檢視] (2 tabs)
  - 儀表板 (總覽頁) → / [檢視]

📁 導航結構:
  儀表板
  主資料
    ├── 商品管理
    └── 倉庫管理
  員工管理

以上規格是否正確？
  ✅ 確認，開始生成
  ✏️ 我想調整（請說明要修改的部分）
```

### Step 4 — User confirms

```
User: ✅ 確認
```

### Step 5 — Project name (already inferred from doc)

```
Claude: 專案名稱使用 warehouse-admin，確認嗎？
User: OK
```

### Step 6 — Deployment choice

```
Claude: 生成完成後，是否需要部署？
  1. 僅本地生成（預設）
  2. 推送到 GitHub 組織
  3. 部署到 Cloudflare Pages
  4. 以上都要

User: 1
```

### Step 7 — Generation (prototype-generator agent)

```
Claude:
✅ Step 1/6: Project scaffold created
✅ Step 2/6: Layout and theme configured
✅ Step 3/6: Type definitions generated (3 entities)
✅ Step 4/6: Mock data hooks generated (3 hooks)
✅ Step 5/6: Pages generated (5 pages)
✅ Step 6/6: Build verified successfully

╔══════════════════════════════════════════════════��
║  ProtoForge — Prototype Generated Successfully   ║
╚══════════════════════════════════════════════════╝

📋 Project:     warehouse-admin
📝 Description: 倉儲管理系統原型

🗄️ Entities (3): Product, Warehouse, Employee
📄 Pages (5):    商品管理, 倉庫管理, 員工管理, 員工詳情, 儀表板

📁 Location: ./warehouse-admin/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ▶ 立即預覽（在終端機執行以下指令）:
    cd warehouse-admin && npm install && npm run dev
  🌐 開啟: http://localhost:3000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 6. Features Demonstrated in This Example

| Feature | Where |
|---------|-------|
| `image` field type | Product.image, Employee.avatar |
| `multiselect` field type | Employee.skills |
| `password` field type | Employee.password |
| `select` with cross-entity ref | Warehouse.managerId → Employee |
| `validation` rules | Product.sku (pattern), Product.price (min/max) |
| `export` action | Product list page — CSV download button |
| `tabs` on detail page | Employee detail — 基本資訊 + 負責倉庫 |
| Deterministic seed | Each hook uses `faker.seed(hashCode(entityName))` |
| Referential integrity | Warehouse mock data uses real Employee IDs |
| Enhanced dashboard | Stat cards + status breakdown + recent tables + chart placeholder |
