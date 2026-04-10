# ProjectSpec — Intermediate Representation

The `ProjectSpec` is the structured output from document analysis. It serves as the contract between the analysis phase and the generation phase.

## TypeScript Definition

```typescript
interface ProjectSpec {
  /** Project directory name (kebab-case) */
  projectName: string;
  /** One-line project description */
  description: string;
  /** All entities (data models) extracted from the document */
  entities: EntitySpec[];
  /** All pages to generate */
  pages: PageSpec[];
  /** Sidebar navigation structure */
  navigation: NavItem[];
}

interface EntitySpec {
  /** PascalCase entity name, e.g. "Supplier", "PurchaseOrder" */
  name: string;
  /** All fields for this entity */
  fields: FieldSpec[];
}

interface FieldSpec {
  /** camelCase field name, e.g. "supplierName", "createdAt" */
  name: string;
  /** Field data type — determines which mezzanine-ui component to use */
  type: 'string' | 'text' | 'number' | 'date' | 'datetime' | 'boolean' | 'enum' | 'select';
  /** Whether this field is required in forms */
  required: boolean;
  /** Whether this field appears as a filter above the table */
  isFilterable: boolean;
  /** Whether this field appears as a column in the table */
  isTableColumn: boolean;
  /** Display label (Traditional Chinese) */
  label: string;
  /** For enum type: available option values */
  enumOptions?: string[];
  /** For select type: related entity name (PascalCase) */
  relatedEntity?: string;
}

interface PageSpec {
  /** Page display name (Traditional Chinese) */
  name: string;
  /** Route path without leading slash, e.g. "suppliers", "purchase-orders" */
  route: string;
  /** Page type — determines which template pattern to use */
  type: 'list' | 'detail' | 'form' | 'dashboard';
  /** Which entity this page manages (PascalCase entity name) */
  entityRef: string;
  /** Available CRUD actions on this page */
  actions: ('create' | 'edit' | 'delete' | 'view' | 'export')[];
}

interface NavItem {
  /** Display label (Traditional Chinese) */
  label: string;
  /** mezzanine-ui icon name (from @mezzanine-ui/icons) */
  icon: string;
  /** Route path (matches PageSpec.route), omit for parent groups */
  route?: string;
  /** Child navigation items (for grouped menus) */
  children?: NavItem[];
}
```

## Example ProjectSpec

```json
{
  "projectName": "warehouse-admin",
  "description": "倉儲管理系統原型",
  "entities": [
    {
      "name": "Product",
      "fields": [
        { "name": "name", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "商品名稱" },
        { "name": "sku", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "SKU" },
        { "name": "category", "type": "enum", "required": true, "isFilterable": true, "isTableColumn": true, "label": "分類", "enumOptions": ["原物料", "半成品", "成品"] },
        { "name": "price", "type": "number", "required": true, "isFilterable": false, "isTableColumn": true, "label": "單價" },
        { "name": "isActive", "type": "boolean", "required": false, "isFilterable": true, "isTableColumn": true, "label": "啟用狀態" },
        { "name": "createdAt", "type": "date", "required": false, "isFilterable": true, "isTableColumn": true, "label": "建立日期" }
      ]
    },
    {
      "name": "Warehouse",
      "fields": [
        { "name": "name", "type": "string", "required": true, "isFilterable": true, "isTableColumn": true, "label": "倉庫名稱" },
        { "name": "location", "type": "string", "required": true, "isFilterable": false, "isTableColumn": true, "label": "地址" },
        { "name": "capacity", "type": "number", "required": true, "isFilterable": false, "isTableColumn": true, "label": "容量" }
      ]
    }
  ],
  "pages": [
    { "name": "商品管理", "route": "products", "type": "list", "entityRef": "Product", "actions": ["create", "edit", "delete"] },
    { "name": "倉庫管理", "route": "warehouses", "type": "list", "entityRef": "Warehouse", "actions": ["create", "edit", "view"] }
  ],
  "navigation": [
    {
      "label": "主資料",
      "icon": "FolderIcon",
      "children": [
        { "label": "商品管理", "icon": "BoxIcon", "route": "products" },
        { "label": "倉庫管理", "icon": "FolderMoveIcon", "route": "warehouses" }
      ]
    }
  ]
}
```

## Guidelines for Extraction

1. **Entity identification**: Look for nouns that represent data objects (customers, orders, products, etc.)
2. **Field inference**: Extract attributes mentioned for each entity; infer types from context (dates, amounts, statuses)
3. **Page planning**: Each entity typically gets a list page; entities with complex details get a detail page
4. **Navigation grouping**: Group related entities under a common parent (e.g., "主資料", "營運管理", "系統設定")
5. **Action inference**: CRUD is default for list pages; read-only entities get only "view"
6. **Always include an `id` field** (type: string) for every entity, even if not shown in table/form — it's needed for mock data keying
