# Quadrats Mark Serializer Detailed Parameters

## Common Interfaces

### JsxSerializeLeafProps

Props interface for all mark serializers:

```typescript
interface JsxSerializeLeafProps {
  children: any;  // Child elements (already serialized text)
  leaf: {
    text: string;
    bold?: boolean;
    italic?: boolean;
    underline?: boolean;
    strikethrough?: boolean;
    highlight?: boolean | string;
    // ...other marks
  };
}
```

### CreateJsxSerializeMarkOptions

Options for creating a mark serializer:

```typescript
interface CreateJsxSerializeMarkOptions {
  mark: string;                              // Mark name
  render: (props: JsxSerializeLeafProps) => JSX.Element;  // Render function
}
```

---

## Mark Serializers

### Bold

```typescript
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';

const boldSerializer = createJsxSerializeBold({
  render: ({ children }) => <strong>{children}</strong>,
});
```

**Props**:
| Property    | Type      | Description     |
|-------------|-----------|-----------------|
| `leaf.bold` | `boolean` | Whether bold    |

**Default output**: `<strong>{children}</strong>`

---

### Italic

```typescript
import { createJsxSerializeItalic } from '@quadrats/react/italic/jsx-serializer';

const italicSerializer = createJsxSerializeItalic({
  render: ({ children }) => <em>{children}</em>,
});
```

**Props**:
| Property      | Type      | Description      |
|---------------|-----------|------------------|
| `leaf.italic` | `boolean` | Whether italic   |

**Default output**: `<em>{children}</em>`

---

### Underline

```typescript
import { createJsxSerializeUnderline } from '@quadrats/react/underline/jsx-serializer';

const underlineSerializer = createJsxSerializeUnderline({
  render: ({ children }) => <u>{children}</u>,
});
```

**Props**:
| Property         | Type      | Description        |
|------------------|-----------|--------------------|
| `leaf.underline` | `boolean` | Whether underlined |

**Default output**: `<u>{children}</u>`

---

### Strikethrough

```typescript
import { createJsxSerializeStrikethrough } from '@quadrats/react/strikethrough/jsx-serializer';

const strikethroughSerializer = createJsxSerializeStrikethrough({
  render: ({ children }) => <s>{children}</s>,
});
```

**Props**:
| Property             | Type      | Description             |
|----------------------|-----------|-------------------------|
| `leaf.strikethrough` | `boolean` | Whether strikethrough   |

**Default output**: `<s>{children}</s>`

---

### Highlight

```typescript
import { createJsxSerializeHighlight } from '@quadrats/react/highlight/jsx-serializer';

// Basic usage (single color)
const highlightSerializer = createJsxSerializeHighlight({
  render: ({ children }) => (
    <mark className="qdr-highlight">{children}</mark>
  ),
});

// Multi-color variant
const highlightSerializerWithVariants = createJsxSerializeHighlight({
  render: ({ children, leaf }) => {
    // leaf.highlight can be boolean or a variant string
    const variant = typeof leaf.highlight === 'string'
      ? leaf.highlight
      : 'default';

    return (
      <mark className={`qdr-highlight qdr-highlight--${variant}`}>
        {children}
      </mark>
    );
  },
});
```

**Props**:
| Property         | Type                | Description                              |
|------------------|---------------------|------------------------------------------|
| `leaf.highlight` | `boolean \| string` | Highlight mark; string is a variant name |

**Default output**: `<mark className="qdr-highlight">{children}</mark>`

**Suggested variant styles**:

```css
.qdr-highlight { background-color: #fef08a; }
.qdr-highlight--yellow { background-color: #fef08a; }
.qdr-highlight--green { background-color: #bbf7d0; }
.qdr-highlight--blue { background-color: #bfdbfe; }
.qdr-highlight--pink { background-color: #fbcfe8; }
.qdr-highlight--orange { background-color: #fed7aa; }
```

---

## Custom Mark Serializers

Use the low-level API to create custom marks:

```typescript
import { createJsxSerializeMark } from '@quadrats/react/jsx-serializer';

// Custom color mark
const colorSerializer = createJsxSerializeMark({
  mark: 'color',
  render: ({ children, leaf }) => (
    <span style={{ color: leaf.color }}>{children}</span>
  ),
});

// Custom font size mark
const fontSizeSerializer = createJsxSerializeMark({
  mark: 'fontSize',
  render: ({ children, leaf }) => (
    <span style={{ fontSize: leaf.fontSize }}>{children}</span>
  ),
});
```

---

## Multi-Mark Combined Serialization

Multiple marks can be applied simultaneously to the same text:

```typescript
// Data example: bold + italic
const leaf = {
  text: "Important text",
  bold: true,
  italic: true,
};

// Serializers apply in sequence
// Output: <strong><em>Important text</em></strong>
```

Serializer execution order is determined by the `leafs` array order:

```typescript
const serializer = createJsxSerializer({
  leafs: [
    createJsxSerializeBold(),       // Outermost layer
    createJsxSerializeItalic(),     // Second layer
    createJsxSerializeUnderline(),  // Innermost layer
  ],
});
```

---

## Default CSS Classes

| Mark          | Default Class                  |
|---------------|--------------------------------|
| Bold          | None (uses `<strong>`)         |
| Italic        | None (uses `<em>`)             |
| Underline     | None (uses `<u>`)              |
| Strikethrough | None (uses `<s>`)              |
| Highlight     | `qdr-highlight`                |

---

## Full Integration Example

```typescript
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { createJsxSerializeItalic } from '@quadrats/react/italic/jsx-serializer';
import { createJsxSerializeUnderline } from '@quadrats/react/underline/jsx-serializer';
import { createJsxSerializeStrikethrough } from '@quadrats/react/strikethrough/jsx-serializer';
import { createJsxSerializeHighlight } from '@quadrats/react/highlight/jsx-serializer';

const serializer = createJsxSerializer({
  elements: [
    createJsxSerializeParagraph(),
  ],
  leafs: [
    createJsxSerializeBold(),
    createJsxSerializeItalic(),
    createJsxSerializeUnderline(),
    createJsxSerializeStrikethrough(),
    createJsxSerializeHighlight(),
  ],
});

// Usage
function Content({ data }: { data: Descendant[] }) {
  return <div>{serializer.serialize(data)}</div>;
}
```
