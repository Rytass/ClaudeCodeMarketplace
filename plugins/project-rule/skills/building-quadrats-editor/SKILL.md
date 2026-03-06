---
name: building-quadrats-editor
description: Build Quadrats rich text editor for admin/backend. Provides full component parameters (Bold, Italic, Heading, Image, Embed, Table, 20+ components), Toolbar configuration, event handling. Use when building editors, adding editor components, configuring Toolbar, handling keyboard shortcuts, setting up image upload, embedding videos. Related skill — serializing-quadrats (frontend serialization rendering).
---

# Quadrats Editor Setup Guide

> Related skill: For frontend rendering, see `serializing-quadrats` skill

## Installation

```bash
npm install @quadrats/react @quadrats/icons @quadrats/locales @quadrats/utils @quadrats/theme
```

Install the corresponding packages based on the components you need (see [COMPONENTS.md](COMPONENTS.md)).

## Quick Start

### Minimal Editor

```typescript
import { pipe } from '@quadrats/utils';
import { Quadrats, Editable, createReactEditor, composeRenderElements, Descendant } from '@quadrats/react';
import { createReactParagraph } from '@quadrats/react/paragraph';
import { createReactLineBreak } from '@quadrats/react/line-break';

// 1. Create components
const paragraph = createReactParagraph();
const lineBreak = createReactLineBreak();

// 2. Compose editor
const editor = pipe(
  createReactEditor(),
  lineBreak.with,
);

// 3. Compose renderers
const renderElement = composeRenderElements([
  paragraph.createRenderElement(),
  lineBreak.createRenderElement(),
]);

// 4. React component
function MyEditor() {
  const [value, setValue] = useState<Descendant[]>([
    { type: 'paragraph', children: [{ text: '' }] }
  ]);

  return (
    <Quadrats editor={editor} value={value} onChange={setValue}>
      <Editable renderElement={renderElement} />
    </Quadrats>
  );
}
```

### Adding Text Formatting (Bold, Italic)

```typescript
import { createReactBold } from '@quadrats/react/bold';
import { createReactItalic } from '@quadrats/react/italic';
import { composeRenderLeafs, composeHandlers } from '@quadrats/react';

const bold = createReactBold();
const italic = createReactItalic();

// Compose leaf renderers (for marks)
const renderLeaf = composeRenderLeafs([
  bold.createRenderLeaf(),
  italic.createRenderLeaf(),
]);

// Compose event handlers (enable shortcuts Mod+B, Mod+I)
const handlers = composeHandlers([
  bold.createHandlers(),
  italic.createHandlers(),
])(editor);

<Editable {...handlers} renderElement={renderElement} renderLeaf={renderLeaf} />
```

---

## Core API

| Function                       | Description                      |
|--------------------------------|----------------------------------|
| `createReactEditor()`          | Create base editor instance      |
| `pipe(...fns)`                 | Compose multiple `.with` functions |
| `composeRenderElements([...])` | Compose element renderers        |
| `composeRenderLeafs([...])`    | Compose mark/leaf renderers      |
| `composeHandlers([...])`       | Compose event handlers           |

---

## Component Overview

### Mark Components — Text Formatting
| Component     | Package                           | Shortcut        |
|---------------|-----------------------------------|-----------------|
| Bold | `@quadrats/react/bold` | `Mod+B` |
| Italic | `@quadrats/react/italic` | `Mod+I` |
| Underline | `@quadrats/react/underline` | `Mod+U` |
| Strikethrough | `@quadrats/react/strikethrough` | `Mod+Shift+X` |
| Highlight | `@quadrats/react/highlight` | `Mod+Shift+H` |

### Block Components
| Component  | Package                           | Purpose                    |
|------------|-----------------------------------|----------------------------|
| Paragraph  | `@quadrats/react/paragraph`       | Paragraph (required)       |
| Heading    | `@quadrats/react/heading`         | Headings h1-h6             |
| LineBreak  | `@quadrats/react/line-break`      | Soft line break (required) |
| Blockquote | `@quadrats/react/blockquote`      | Block quote                |
| Divider    | `@quadrats/react/divider`         | Horizontal divider         |
| List       | `@quadrats/react/list`            | Ordered/unordered lists    |
| Table      | `@quadrats/react/table`           | Table                      |
| Accordion  | `@quadrats/react/accordion`       | Collapsible panel          |

### Media Components
| Component | Package                        | Purpose                        |
|-----------|--------------------------------|--------------------------------|
| Image     | `@quadrats/react/image`        | Image upload and display       |
| Carousel  | `@quadrats/react/carousel`     | Image carousel                 |
| Card      | `@quadrats/react/card`         | Card component                 |
| Embed     | `@quadrats/react/embed`        | Embed videos (YouTube, etc.)   |

### Special Components
| Component  | Package                         | Purpose            |
|------------|---------------------------------|--------------------|
| Link       | `@quadrats/react/link`          | Hyperlink          |
| Footnote   | `@quadrats/react/footnote`      | Footnote           |
| ReadMore   | `@quadrats/react/read-more`     | Read more divider  |
| Align      | `@quadrats/react/align`         | Text alignment     |
| InputBlock | `@quadrats/react/input-block`   | Input block        |

---

## Detailed Documentation

- **Full component parameters** → [COMPONENTS.md](COMPONENTS.md)
- **Toolbar configuration** → [TOOLBAR.md](TOOLBAR.md)
- **Complete implementation examples** → [EXAMPLES.md](EXAMPLES.md)
- **Advanced features (Hooks, Utils, low-level API)** → [ADVANCED.md](ADVANCED.md)
- **CSS variables reference** → [CSS_VARIABLES.md](CSS_VARIABLES.md)

---

## Theming and Localization

```typescript
import { ConfigsProvider } from '@quadrats/react/configs';
import { zhTW, enUS } from '@quadrats/locales';

<ConfigsProvider locale={zhTW} theme="light">
  <Quadrats editor={editor} value={value} onChange={setValue}>
    <Editable />
  </Quadrats>
</ConfigsProvider>
```

| Locale             | Package             | Variable |
|--------------------|---------------------|----------|
| Traditional Chinese | `@quadrats/locales` | `zhTW`   |
| English            | `@quadrats/locales` | `enUS`   |

| Theme | Value    |
|-------|----------|
| Light | `"light"` |
| Dark  | `"dark"`  |
