# Tab Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Tab`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Tab) · Verified 1.1.0 (2026-04-24)

Tab component for switching between different content views within the same area.

## Import

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';
import type { TabProps, TabItemProps, TabsChild } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/?path=/docs/navigation-tab--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Type Definition

```ts
type TabsChild = ReactElement<TabItemProps>;
```

---

## Tab Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>` (excluding `onChange` and `children`).

| Property           | Type                                      | Default        | Description          |
| ------------------ | ----------------------------------------- | -------------- | -------------------- |
| `activeKey`        | `Key`                                     | -              | Controlled active tab |
| `children`         | `TabsChild \| TabsChild[]`               | **required**   | TabItem children     |
| `defaultActiveKey` | `Key`                                     | `0`            | Default active tab   |
| `direction`        | `'horizontal' \| 'vertical'`             | `'horizontal'` | Layout direction     |
| `onChange`         | `(activeKey: Key, index: number) => void` | -              | Change event         |
| `size`             | `'main' \| 'sub'`                         | `'main'`       | Tab group size (controls padding) |

---

## TabItem Props

> Extends `NativeElementPropsWithoutKeyAndRef<'button'>`.

| Property     | Type             | Default | Description                           |
| ------------ | ---------------- | ------- | ------------------------------------- |
| `active`     | `boolean`        | -       | Whether active (controlled by `<Tab>`) |
| `badgeCount` | `number`         | -       | Badge number on the tab               |
| `children`   | `ReactNode`      | -       | Tab content                           |
| `disabled`   | `boolean`        | `false` | Whether disabled                      |
| `error`      | `boolean`        | `false` | Error state variant (changes badge styling) |
| `icon`       | `IconDefinition` | -       | Tab icon                              |

---

## Usage Examples

### Basic Usage

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';

function BasicTab() {
  return (
    <Tab>
      <TabItem key="tab1">Tab 1</TabItem>
      <TabItem key="tab2">Tab 2</TabItem>
      <TabItem key="tab3">Tab 3</TabItem>
    </Tab>
  );
}
```

### Controlled Mode

```tsx
function ControlledTab() {
  const [activeKey, setActiveKey] = useState<Key>('tab1');

  return (
    <>
      <Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
        <TabItem key="tab1">Tab 1</TabItem>
        <TabItem key="tab2">Tab 2</TabItem>
        <TabItem key="tab3">Tab 3</TabItem>
      </Tab>
      <div>
        {activeKey === 'tab1' && <div>Content 1</div>}
        {activeKey === 'tab2' && <div>Content 2</div>}
        {activeKey === 'tab3' && <div>Content 3</div>}
      </div>
    </>
  );
}
```

### Vertical Layout

```tsx
<Tab direction="vertical">
  <TabItem key="overview">Overview</TabItem>
  <TabItem key="details">Details</TabItem>
  <TabItem key="settings">Settings</TabItem>
</Tab>
```

### Default Selected

```tsx
<Tab defaultActiveKey="tab2">
  <TabItem key="tab1">Tab 1</TabItem>
  <TabItem key="tab2">Tab 2 (default)</TabItem>
  <TabItem key="tab3">Tab 3</TabItem>
</Tab>
```

### With Icons and Badges

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';
import { HomeIcon, UserIcon, SettingIcon } from '@mezzanine-ui/icons';

<Tab>
  <TabItem key="home" icon={HomeIcon}>Home</TabItem>
  <TabItem key="users" icon={UserIcon} badgeCount={5}>Users</TabItem>
  <TabItem key="settings" icon={SettingIcon}>Settings</TabItem>
</Tab>
```

### Tab Group Sizes

```tsx
// Main size (default) - larger padding
<Tab size="main">
  <TabItem key="tab1">Main Tab</TabItem>
  <TabItem key="tab2">Another Tab</TabItem>
</Tab>

// Sub size - compact padding
<Tab size="sub">
  <TabItem key="tab1">Compact Tab</TabItem>
  <TabItem key="tab2">Another Tab</TabItem>
</Tab>
```

### Error State on Tab Item

```tsx
// Error badge displays with alert variant (instead of default brand color)
<Tab>
  <TabItem key="form" icon={FormIcon}>Form</TabItem>
  <TabItem key="review" icon={ReviewIcon} badgeCount={3} error>
    Review
  </TabItem>
  <TabItem key="submit" icon={SendIcon}>Submit</TabItem>
</Tab>

// When error is true, badge variant changes to 'count-alert' to indicate issues
```

### Disabled Tab

```tsx
<Tab>
  <TabItem key="tab1">Available Tab</TabItem>
  <TabItem key="tab2" disabled>Disabled Tab</TabItem>
  <TabItem key="tab3">Available Tab</TabItem>
</Tab>
```

### With Content Panels

```tsx
function TabWithContent() {
  const [activeKey, setActiveKey] = useState<Key>('profile');

  return (
    <div>
      <Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
        <TabItem key="profile">Profile</TabItem>
        <TabItem key="account">Account Settings</TabItem>
        <TabItem key="notifications">Notifications</TabItem>
      </Tab>

      <div style={{ padding: '16px' }}>
        {activeKey === 'profile' && <ProfileContent />}
        {activeKey === 'account' && <AccountContent />}
        {activeKey === 'notifications' && <NotificationsContent />}
      </div>
    </div>
  );
}
```

### Dynamic Tabs

```tsx
function DynamicTabs() {
  const [tabs, setTabs] = useState([
    { key: '1', label: 'Tab 1' },
    { key: '2', label: 'Tab 2' },
  ]);

  const addTab = () => {
    const newKey = String(tabs.length + 1);
    setTabs([...tabs, { key: newKey, label: `Tab ${newKey}` }]);
  };

  return (
    <>
      <Tab>
        {tabs.map((tab) => (
          <TabItem key={tab.key}>{tab.label}</TabItem>
        ))}
      </Tab>
      <Button onClick={addTab}>Add Tab</Button>
    </>
  );
}
```

---

## Figma Mapping

| Figma Variant             | React Props                              |
| ------------------------- | ---------------------------------------- |
| `Tab / Main`              | `<Tab size="main">`                      |
| `Tab / Sub`               | `<Tab size="sub">`                       |
| `Tab / Horizontal`        | `<Tab direction="horizontal">`           |
| `Tab / Vertical`          | `<Tab direction="vertical">`             |
| `TabItem / Active`        | Determined by `activeKey`                |
| `TabItem / Disabled`      | `<TabItem disabled>`                     |
| `TabItem / Error`         | `<TabItem error>`                        |

---

## Best Practices

1. **Meaningful keys**: Use descriptive key values
2. **Limit tab count**: Recommend 2-7 tabs
3. **Concise tab text**: Keep tab text short
4. **Pair with content panels**: Tab only handles switching; content must be implemented separately
5. **Vertical for sidebars**: Side settings panels suit `direction="vertical"`
