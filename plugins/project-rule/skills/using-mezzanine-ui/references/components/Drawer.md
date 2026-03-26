# Drawer Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Drawer`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Drawer) · Verified rc.7 source (2026-03-26)

A drawer component that slides out from the edge of the page, used to display detailed information or forms.

## Import

```tsx
import { Drawer } from '@mezzanine-ui/react';
import type { DrawerProps, DrawerPlacement } from '@mezzanine-ui/react';
```

---

## Drawer Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>` and partial `BackdropProps`.

### Core Props

| Property                      | Type              | Default    | Description                    |
| ----------------------------- | ----------------- | ---------- | ------------------------------ |
| `open`                        | `boolean`         | -          | Whether the drawer is open     |
| `onClose`                     | `VoidFunction`    | -          | Close event handler            |
| `children`                    | `ReactNode`       | -          | Content                        |
| `size`                        | `DrawerSize`      | `'medium'` | Width size                     |
| `headerTitle`                 | `string`          | -          | Header title text              |
| `isHeaderDisplay`             | `boolean`         | -          | Whether to show header area    |
| `isBottomDisplay`             | `boolean`         | -          | Whether to show bottom area    |
| `container`                   | `Element`         | -          | Portal container               |
| `disablePortal`               | `boolean`         | -          | Disable Portal                 |
| `disableCloseOnBackdropClick` | `boolean`         | `false`    | Disable close on backdrop click|
| `disableCloseOnEscapeKeyDown` | `boolean`         | `false`    | Disable close on ESC key       |
| `contentKey`                  | `React.Key`       | -          | Remounts drawer content on change, prevents stale DOM state |
| `onBackdropClick`             | `() => void`      | -          | Backdrop click event handler   |

### Bottom Ghost Button Props

| Property                          | Type              | Default         | Description          |
| --------------------------------- | ----------------- | --------------- | -------------------- |
| `bottomGhostActionText`           | `string`          | -               | Button text          |
| `bottomOnGhostActionClick`        | `VoidFunction`    | -               | Click event handler  |
| `bottomGhostActionDisabled`       | `boolean`         | -               | Whether disabled     |
| `bottomGhostActionIcon`           | `IconDefinition`  | -               | Button icon          |
| `bottomGhostActionIconType`       | `ButtonIconType`  | -               | Icon position        |
| `bottomGhostActionLoading`        | `boolean`         | -               | Loading state        |
| `bottomGhostActionSize`           | `ButtonSize`      | -               | Button size          |
| `bottomGhostActionVariant`        | `ButtonVariant`   | `'base-ghost'`  | Button variant       |

### Bottom Primary Button Props

| Property                          | Type              | Default           | Description          |
| --------------------------------- | ----------------- | ----------------- | -------------------- |
| `bottomPrimaryActionText`         | `string`          | -                 | Button text          |
| `bottomOnPrimaryActionClick`      | `VoidFunction`    | -                 | Click event handler  |
| `bottomPrimaryActionDisabled`     | `boolean`         | -                 | Whether disabled     |
| `bottomPrimaryActionIcon`         | `IconDefinition`  | -                 | Button icon          |
| `bottomPrimaryActionIconType`     | `ButtonIconType`  | -                 | Icon position        |
| `bottomPrimaryActionLoading`      | `boolean`         | -                 | Loading state        |
| `bottomPrimaryActionSize`         | `ButtonSize`      | -                 | Button size          |
| `bottomPrimaryActionVariant`      | `ButtonVariant`   | `'base-primary'`  | Button variant       |

### Bottom Secondary Button Props

| Property                            | Type              | Default             | Description          |
| ----------------------------------- | ----------------- | ------------------- | -------------------- |
| `bottomSecondaryActionText`         | `string`          | -                   | Button text          |
| `bottomOnSecondaryActionClick`      | `VoidFunction`    | -                   | Click event handler  |
| `bottomSecondaryActionDisabled`     | `boolean`         | -                   | Whether disabled     |
| `bottomSecondaryActionIcon`         | `IconDefinition`  | -                   | Button icon          |
| `bottomSecondaryActionIconType`     | `ButtonIconType`  | -                   | Icon position        |
| `bottomSecondaryActionLoading`      | `boolean`         | -                   | Loading state        |
| `bottomSecondaryActionSize`         | `ButtonSize`      | -                   | Button size          |
| `bottomSecondaryActionVariant`      | `ButtonVariant`   | `'base-secondary'`  | Button variant       |

### Filter Area Props

| Property                          | Type                                    | Default      | Description                    |
| --------------------------------- | --------------------------------------- | ------------ | ------------------------------ |
| `filterAreaShow`                  | `boolean`                               | `false`      | Whether to show filter area    |
| `filterAreaAllRadioLabel`         | `string`                                | -            | Filter area "All" label        |
| `filterAreaReadRadioLabel`        | `string`                                | -            | Filter area "Read" label       |
| `filterAreaUnreadRadioLabel`      | `string`                                | -            | Filter area "Unread" label     |
| `filterAreaShowUnreadButton`      | `boolean`                               | `false`      | Whether to show unread button  |
| `filterAreaCustomButtonLabel`     | `string`                                | `'全部已讀'`      | Custom button text             |
| `filterAreaOnCustomButtonClick`   | `VoidFunction`                          | -            | Custom button click handler    |
| `filterAreaOnRadioChange`         | `ChangeEventHandler<HTMLInputElement>`  | -            | Radio change event handler     |
| `filterAreaDefaultValue`          | `string`                                | -            | Default radio value            |
| `filterAreaValue`                 | `string`                                | -            | Controlled radio value         |
| `filterAreaIsEmpty`               | `boolean`                               | `false`      | Whether to disable custom btn  |
| `filterAreaOptions`               | `DropdownOption[]`                      | -            | Options for dropdown in filter area |
| `filterAreaOnSelect`              | `(option: DropdownOption) => void`      | -            | Callback when dropdown option selected |

---

## Type Definitions

```ts
type DrawerSize = 'narrow' | 'medium' | 'wide';
// Note: DrawerSize must be imported from @mezzanine-ui/core/drawer

// DrawerPlacement is exported but the Drawer component currently uses fixed right placement, does not use placement prop
type DrawerPlacement = 'top' | 'right' | 'bottom' | 'left';
```

### DrawerSize

| Size     | Description   |
| -------- | ------------- |
| `narrow` | Narrow drawer |
| `medium` | Medium drawer |
| `wide`   | Wide drawer   |

---

## Usage Examples

### Basic Usage

```tsx
import { Drawer, Button } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicDrawer() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button onClick={() => setOpen(true)}>Open Drawer</Button>
      <Drawer
        open={open}
        onClose={() => setOpen(false)}
        isHeaderDisplay
        headerTitle="Drawer Title"
      >
        <p>Drawer content</p>
      </Drawer>
    </>
  );
}
```

### Different Sizes

```tsx
// Narrow
<Drawer size="narrow" open={open} onClose={onClose}>
  Narrow drawer content
</Drawer>

// Medium (default)
<Drawer size="medium" open={open} onClose={onClose}>
  Medium drawer content
</Drawer>

// Wide
<Drawer size="wide" open={open} onClose={onClose}>
  Wide drawer content
</Drawer>
```

### With Header and Bottom

```tsx
<Drawer
  open={open}
  onClose={onClose}
  isHeaderDisplay
  headerTitle="Edit User"
  isBottomDisplay
  bottomPrimaryActionText="Save"
  bottomOnPrimaryActionClick={handleSave}
  bottomSecondaryActionText="Cancel"
  bottomOnSecondaryActionClick={onClose}
>
  <UserForm />
</Drawer>
```

### With Three Bottom Buttons

```tsx
<Drawer
  open={open}
  onClose={onClose}
  isHeaderDisplay
  headerTitle="Advanced Settings"
  isBottomDisplay
  bottomGhostActionText="Reset"
  bottomOnGhostActionClick={handleReset}
  bottomSecondaryActionText="Cancel"
  bottomOnSecondaryActionClick={onClose}
  bottomPrimaryActionText="Apply"
  bottomOnPrimaryActionClick={handleApply}
>
  <SettingsForm />
</Drawer>
```

### Disable Backdrop Click Close

```tsx
<Drawer
  open={open}
  onClose={onClose}
  disableCloseOnBackdropClick
  isHeaderDisplay
  headerTitle="Important Form"
>
  <ImportantForm />
</Drawer>
```

### Disable ESC Close

```tsx
<Drawer
  open={open}
  onClose={onClose}
  disableCloseOnEscapeKeyDown
  isHeaderDisplay
  headerTitle="Fill Form"
>
  <FormContent />
</Drawer>
```

### Form Drawer

```tsx
function FormDrawer() {
  const [open, setOpen] = useState(false);
  const [formData, setFormData] = useState({ name: '', email: '' });

  const handleSave = () => {
    // Save logic
    setOpen(false);
  };

  return (
    <>
      <Button onClick={() => setOpen(true)}>Add User</Button>
      <Drawer
        open={open}
        onClose={() => setOpen(false)}
        size="medium"
        isHeaderDisplay
        headerTitle="Add User"
        isBottomDisplay
        bottomPrimaryActionText="Save"
        bottomOnPrimaryActionClick={handleSave}
        bottomSecondaryActionText="Cancel"
        bottomOnSecondaryActionClick={() => setOpen(false)}
      >
        <FormField name="name" label="Name" layout="vertical" required>
          <Input
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          />
        </FormField>
        <FormField name="email" label="Email" layout="vertical" required>
          <Input
            inputType="email"
            value={formData.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          />
        </FormField>
      </Drawer>
    </>
  );
}
```

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `Drawer / Narrow`                | `size="narrow"`                          |
| `Drawer / Medium`                | `size="medium"`                          |
| `Drawer / Wide`                  | `size="wide"`                            |
| `Drawer / With Header`           | `isHeaderDisplay`                        |
| `Drawer / With Bottom Actions`   | `isBottomDisplay`                        |
| `Drawer / Full`                  | `isHeaderDisplay isBottomDisplay`        |

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 詳情檢視 | `size="medium"`, `isHeaderDisplay` | 檢視額外詳細資訊 |
| 表單編輯 | `size="wide"`, `isHeaderDisplay`, `isBottomDisplay` | 寬抽屜容納完整表單，底部按鈕群 |
| 快速設定 | `size="narrow"`, 最少按鈕 | 簡單設定使用窄抽屜 |
| 重要表單 | `disableCloseOnBackdropClick`, `disableCloseOnEscapeKeyDown` | 防止意外關閉 |
| 列表操作 | `size="medium"`, 滾動內容 | 呈現清單或多筆項目 |

### 常見錯誤

1. **RC.7 重大更新: controlBar → filterArea 轉換**
   ```tsx
   // ❌ 錯誤 (RC.6 已廢棄)：
   <Drawer
     controlBarShow
     controlBarAllRadioLabel="全部"
     controlBarValue={filter}
     controlBarOnRadioChange={handleChange}
   >
     Content
   </Drawer>

   // ✅ 正確 (RC.7)：
   <Drawer
     filterAreaShow
     filterAreaAllRadioLabel="全部"
     filterAreaValue={filter}
     filterAreaOnRadioChange={handleChange}
   >
     Content
   </Drawer>

   // 與 Dropdown 配合 (RC.7)：
   <Drawer
     filterAreaShow
     filterAreaOptions={dropdownOptions}
     filterAreaOnSelect={handleDropdownSelect}
   >
     Content
   </Drawer>
   ```

2. **尺寸選擇不當導致佈局混亂**
   ```tsx
   // ❌ 錯誤：複雜表單用窄抽屜
   <Drawer size="narrow" isBottomDisplay>
     <ComplexForm />
   </Drawer>

   // ✅ 正確：根據內容複雜度選擇尺寸
   <Drawer size="wide" isBottomDisplay>
     <ComplexForm />
   </Drawer>
   ```

2. **未提供關閉方式**
   ```tsx
   // ❌ 錯誤：使用者無法關閉
   <Drawer open={open}>
     Content only
   </Drawer>

   // ✅ 正確：提供多個關閉方式
   <Drawer
     open={open}
     onClose={onClose}
     isHeaderDisplay
     headerTitle="Title"
     isBottomDisplay
     bottomSecondaryActionText="Close"
     bottomOnSecondaryActionClick={onClose}
   >
     Content
   </Drawer>
   ```

3. **使用 contentKey 不當**
   ```tsx
   // ❌ 錯誤：每次渲染都改變 contentKey
   <Drawer contentKey={Math.random()} open={open}>
     Content
   </Drawer>

   // ✅ 正確：只在數據變更時改變 contentKey
   <Drawer contentKey={dataId} open={open}>
     <DataContent id={dataId} />
   </Drawer>
   ```

4. **底部按鈕設定邏輯錯誤**
   ```tsx
   // ❌ 錯誤：三個按鈕都啟用導致佈局擁擠
   <Drawer
     isBottomDisplay
     bottomGhostActionText="A"
     bottomSecondaryActionText="B"
     bottomPrimaryActionText="C"
   >
     Content
   </Drawer>

   // ✅ 正確：根據場景選擇必要按鈕
   <Drawer
     isBottomDisplay
     bottomSecondaryActionText="Cancel"
     bottomPrimaryActionText="Save"
   >
     Form content
   </Drawer>
   ```

5. **多層抽屜的管理**
   ```tsx
   // ❌ 錯誤：嵌套多個抽屜但無序處理
   <Drawer open={drawer1Open} onClose={() => setDrawer1Open(false)}>
     <Drawer open={drawer2Open} onClose={() => setDrawer2Open(false)}>
       Nested
     </Drawer>
   </Drawer>

   // ✅ 正確：使用堆疊結構，ESC 自動閉合頂層
   <Drawer open={drawer1Open} onClose={() => setDrawer1Open(false)}>
     <Button onClick={() => setDrawer2Open(true)}>Open Second</Button>
   </Drawer>
   <Drawer open={drawer2Open} onClose={() => setDrawer2Open(false)}>
     Content
   </Drawer>
   ```

### 核心原則

1. **選擇適當尺寸**: 根據內容量選擇 `size`
2. **提供關閉方式**: 確保用戶能夠關閉抽屜
3. **表單使用底部按鈕**: 表單抽屜應使用底部操作區域
4. **重要操作禁用意外關閉**: 防止關鍵操作被意外關閉
5. **堆疊處理**: 多個抽屜時，ESC 只關閉頂層
6. **contentKey 管理**: 僅在內容數據確實改變時修改
7. **無障礙設計**: 提供 ARIA 標籤和適當的焦點管理
