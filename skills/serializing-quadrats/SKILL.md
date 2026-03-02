---
name: serializing-quadrats
description: Quadrats frontend content serialization and rendering. Convert Editor JSON content to JSX/HTML. Use when displaying editor content on frontend, customizing element rendering, outputting custom CSS styles, or SSR rendering. Related skill — building-quadrats-editor (backend editor setup).
---

# Quadrats Serializer Frontend Rendering Guide

> Related skill: For backend editor setup, see `building-quadrats-editor` skill

## Installation

```bash
npm install @quadrats/react @quadrats/locales @quadrats/theme
```

Install the corresponding packages based on the serializers you need.

## Quick Start

### Basic Serialization

```typescript
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeLineBreak } from '@quadrats/react/line-break/jsx-serializer';
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { Descendant } from '@quadrats/react';

// 1. Create serializer
const serializer = createJsxSerializer({
  // Element serializers
  elements: [
    createJsxSerializeParagraph(),
    createJsxSerializeLineBreak(),
  ],
  // Mark/leaf serializers
  leafs: [
    createJsxSerializeBold(),
  ],
});

// 2. Use serializer
function ArticleRenderer({ content }: { content: Descendant[] }) {
  return (
    <article className="prose">
      {serializer.serialize(content)}
    </article>
  );
}
```

---

## Core API

### createJsxSerializer

```typescript
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';

interface CreateJsxSerializerOptions {
  // Element serializer array
  elements?: ((props: JsxSerializeElementProps) => JSX.Element | null)[];

  // Mark/leaf serializer array
  leafs?: ((props: JsxSerializeLeafProps) => JSX.Element)[];

  // Default element renderer (when no match)
  defaultElement?: (props: JsxSerializeElementProps) => JSX.Element;

  // Default leaf renderer (when no match)
  defaultLeaf?: (props: JsxSerializeLeafProps) => JSX.Element;
}

const serializer = createJsxSerializer(options);

// Returns
{
  serialize: (nodes: Descendant[]) => JSX.Element
}
```

---

## Serializer Overview

### Element Serializers

| Element    | Package                                            | Function                            |
|------------|----------------------------------------------------|-------------------------------------|
| Paragraph | `@quadrats/react/paragraph/jsx-serializer` | `createJsxSerializeParagraph()` |
| LineBreak | `@quadrats/react/line-break/jsx-serializer` | `createJsxSerializeLineBreak()` |
| Heading | `@quadrats/react/heading/jsx-serializer` | `createJsxSerializeHeading()` |
| Blockquote | `@quadrats/react/blockquote/jsx-serializer` | `createJsxSerializeBlockquote()` |
| Divider | `@quadrats/react/divider/jsx-serializer` | `createJsxSerializeDivider()` |
| List | `@quadrats/react/list/jsx-serializer` | `createJsxSerializeList()` |
| Table | `@quadrats/react/table/jsx-serializer` | `createJsxSerializeTable()` |
| Accordion | `@quadrats/react/accordion/jsx-serializer` | `createJsxSerializeAccordion()` |
| Image | `@quadrats/react/image/jsx-serializer` | `createJsxSerializeImage()` |
| Carousel | `@quadrats/react/carousel/jsx-serializer` | `createJsxSerializeCarousel()` |
| Card | `@quadrats/react/card/jsx-serializer` | `createJsxSerializeCard()` |
| Embed | `@quadrats/react/embed/jsx-serializer` | `createJsxSerializeEmbed()` |
| Link | `@quadrats/react/link/jsx-serializer` | `createJsxSerializeLink()` |
| Footnote | `@quadrats/react/footnote/jsx-serializer` | `createJsxSerializeFootnote()` |
| ReadMore | `@quadrats/react/read-more/jsx-serializer` | `createJsxSerializeReadMore()` |

### Mark/Leaf Serializers

| Mark          | Package                                                | Function                              |
|---------------|--------------------------------------------------------|---------------------------------------|
| Bold | `@quadrats/react/bold/jsx-serializer` | `createJsxSerializeBold()` |
| Italic | `@quadrats/react/italic/jsx-serializer` | `createJsxSerializeItalic()` |
| Underline | `@quadrats/react/underline/jsx-serializer` | `createJsxSerializeUnderline()` |
| Strikethrough | `@quadrats/react/strikethrough/jsx-serializer` | `createJsxSerializeStrikethrough()` |
| Highlight | `@quadrats/react/highlight/jsx-serializer` | `createJsxSerializeHighlight()` |

---

## Theming and Localization

Use `ConfigsProvider` to apply themes during frontend rendering:

```typescript
import { ConfigsProvider } from '@quadrats/react/configs';
import { zhTW } from '@quadrats/locales';

function ArticlePage({ content }: { content: Descendant[] }) {
  return (
    <ConfigsProvider theme="light" locale={zhTW}>
      {({ theme: { props: { style, className } } }) => (
        <div className={className} style={style}>
          {serializer.serialize(content)}
        </div>
      )}
    </ConfigsProvider>
  );
}
```

---

## Detailed Documentation

- **Element serializer parameters** → [ELEMENTS.md](ELEMENTS.md)
- **Mark serializer parameters** → [MARKS.md](MARKS.md)
- **Complete rendering examples** → [EXAMPLES.md](EXAMPLES.md)
- **CSS variables reference** → [CSS_VARIABLES.md](CSS_VARIABLES.md)

---

## Default CSS Classes

Quadrats generates the following CSS classes by default:

| Element    | Class                                                    |
|------------|----------------------------------------------------------|
| Paragraph | `qdr-paragraph` |
| Heading | `qdr-h1`, `qdr-h2`, ..., `qdr-h6` |
| Blockquote | `qdr-blockquote` |
| Divider | `qdr-divider` |
| Link | `qdr-link` |
| Image | `qdr-image`, `qdr-image__figure`, `qdr-image__caption` |
| Table | `qdr-table`, `qdr-table-cell` |
