# Empty Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Empty`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Empty)

An empty state component for displaying placeholder screens when there is no data or in specific states.

## Import

```tsx
import { Empty } from '@mezzanine-ui/react';
import type { EmptyProps } from '@mezzanine-ui/react';
```

---

## Empty Props

`EmptyProps` uses intersection types to combine multiple interfaces. Available props depend on `size` and `type`.

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'title'>`.

### Base Props (BaseEmptyProps)

| Property | Type     | Default | Description            |
| -------- | -------- | ------- | ---------------------- |
| `title`  | `string` | -       | Required, title text   |

### Preset Pictogram Props (PresetPictogramEmptyProps)

| Property    | Type                                                           | Default          | Description                       |
| ----------- | -------------------------------------------------------------- | ---------------- | --------------------------------- |
| `type`      | `'initial-data' \| 'result' \| 'system' \| 'notification'`    | `'initial-data'` | Preset pictogram type             |
| `pictogram` | `ReactNode`                                                    | -                | Custom pictogram (overrides default) |

### Custom Pictogram Props (CustomPictogramEmptyProps)

| Property    | Type        | Default | Description      |
| ----------- | ----------- | ------- | ---------------- |
| `type`      | `'custom'`  | -       | Custom type      |
| `pictogram` | `ReactNode` | -       | Custom pictogram |

### Main/Sub Size Props (MainOrSubEmptyProps)

| Property      | Type                                                                                                                                   | Default  | Description                             |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------------------------- |
| `actions`     | `ButtonProps \| { primaryButton?: ButtonProps; secondaryButton: ButtonProps }`                                                          | -        | Action button config (priority over children) |
| `children`    | `ReactElement<ButtonProps> \| [ReactElement<ButtonProps>] \| [ReactElement<ButtonProps>, ReactElement<ButtonProps>]`                     | -        | 1-2 Button elements (first is secondary) |
| `description` | `string`                                                                                                                               | -        | Description text                        |
| `size`        | `'main' \| 'sub'`                                                                                                                     | `'main'` | Size                                    |

### Minor Size Props (MinorEmptyProps)

| Property      | Type      | Default | Description                              |
| ------------- | --------- | ------- | ---------------------------------------- |
| `size`        | `'minor'` | -       | Required, smallest size                  |
| `actions`     | `never`   | -       | Not available (minor has no action btns) |
| `description` | `never`   | -       | Not available (minor has no description) |

---

## Empty Type

| Type            | Description      | Default Pictogram  |
| --------------- | ---------------- | ------------------ |
| `initial-data`  | Initial no data  | BoxIcon            |
| `result`        | No search result | FolderOpenIcon     |
| `system`        | System error     | SystemIcon         |
| `notification`  | No notifications | NotificationIcon   |
| `custom`        | Custom           | Uses pictogram     |

---

## Empty Size

| Size    | Description | Features                                                    |
| ------- | ----------- | ----------------------------------------------------------- |
| `main`  | Main        | Large icon, full content, supports actions/description/children |
| `sub`   | Sub         | Medium icon, full content, supports actions/description/children |
| `minor` | Minor       | Small icon, title only (no actions, description, or children) |

---

## Usage Examples

### Basic Usage

```tsx
import { Empty } from '@mezzanine-ui/react';

<Empty title="No data available" />
```

### With Description

```tsx
<Empty
  title="No data available"
  description="Please add data to get started"
/>
```

### Different Types

```tsx
// Initial no data
<Empty type="initial-data" title="No data yet" />

// No search results
<Empty type="result" title="No results found" />

// System error
<Empty type="system" title="An error occurred" />

// No notifications
<Empty type="notification" title="No new notifications" />
```

### With Action Buttons

```tsx
// Single button (pass ButtonProps directly)
<Empty
  title="No data available"
  actions={{ content: 'Add Data', onClick: handleAdd }}
/>

// Two buttons (object form: secondaryButton required, primaryButton optional)
<Empty
  title="No data available"
  actions={{
    secondaryButton: { content: 'Learn More', onClick: handleLearnMore },
    primaryButton: { content: 'Add Data', onClick: handleAdd },
  }}
/>
```

### Using Children Buttons

```tsx
import { Empty, Button } from '@mezzanine-ui/react';

{/* First Button is treated as secondary, second as primary */}
<Empty title="No data available">
  <Button onClick={handleLearnMore}>Learn More</Button>
  <Button onClick={handleAdd}>Add Data</Button>
</Empty>
```

### Different Sizes

```tsx
// Main (default)
<Empty size="main" title="Main Size" description="Full content" />

// Sub
<Empty size="sub" title="Sub Size" description="Full content" />

// Minor (does not support actions or description)
<Empty size="minor" title="Minor Size" />
```

### Custom Pictogram

```tsx
import { Empty } from '@mezzanine-ui/react';

<Empty
  type="custom"
  pictogram={<img src="/custom-empty.svg" alt="empty" />}
  title="Custom Empty State"
  description="Using a custom pictogram"
/>
```

### No Search Results

```tsx
function SearchResults({ results, keyword }) {
  if (results.length === 0) {
    return (
      <Empty
        type="result"
        title={`No results found for "${keyword}"`}
        description="Please try different keywords"
        actions={{ content: 'Clear Search', onClick: handleClear }}
      />
    );
  }

  return <ResultList results={results} />;
}
```

### List Empty State

```tsx
function DataList({ data, loading }) {
  if (loading) return <Spin loading />;

  if (data.length === 0) {
    return (
      <Empty
        type="initial-data"
        title="No data yet"
        description="Click the button below to add your first entry"
        actions={{ content: 'Add Data', onClick: handleAdd }}
      />
    );
  }

  return <List data={data} />;
}
```

### Table Empty State

```tsx
<Table
  dataSource={data}
  columns={columns}
  emptyDescription={
    <Empty
      size="sub"
      type="result"
      title="No matching data"
    />
  }
/>
```

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `Empty / Main`                | `size="main"`                            |
| `Empty / Sub`                 | `size="sub"`                             |
| `Empty / Minor`               | `size="minor"`                           |
| `Empty / Initial Data`        | `type="initial-data"`                    |
| `Empty / Result`              | `type="result"`                          |
| `Empty / System`              | `type="system"`                          |
| `Empty / Notification`        | `type="notification"`                    |
| `Empty / With Actions`        | `actions={...}`                          |

---

## Best Practices

1. **Choose appropriate type**: Select the matching type based on the scenario
2. **Provide actions**: Empty states should suggest a next step
3. **Concise copy**: Title and description should be short and clear
4. **Appropriate size**: Choose a suitable size based on container dimensions
5. **Maximum two buttons**: Avoid too many choices
