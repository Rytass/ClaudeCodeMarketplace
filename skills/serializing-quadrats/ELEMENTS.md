# Quadrats Element Serializer Detailed Parameters

## Common Interfaces

### JsxSerializeElementProps

Props interface for all element serializers:

```typescript
interface JsxSerializeElementProps<E extends QuadratsElement = QuadratsElement> {
  children: any;              // Child elements (already serialized)
  element: E & {
    parent?: QuadratsElement; // Parent element reference
  };
}
```

### Using the parent Reference

`element.parent` provides a reference to the parent element, useful for adjusting rendering based on parent type:

```typescript
createJsxSerializeParagraph({
  render: ({ children, element }) => {
    // Check if inside a blockquote
    if (element.parent?.type === 'blockquote') {
      return <p className="blockquote-paragraph">{children}</p>;
    }

    // Check if inside a list item
    if (element.parent?.type === 'li') {
      return <span>{children}</span>;
    }

    return <p className="qdr-paragraph">{children}</p>;
  },
});
```

### CreateJsxSerializeElementOptions

Options for creating a serializer:

```typescript
interface CreateJsxSerializeElementOptions<P> {
  type: string;                              // Element type
  render: (props: P) => JSX.Element | null;  // Render function
}
```

---

## Base Elements

### Paragraph

```typescript
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';

const paragraphSerializer = createJsxSerializeParagraph({
  render: ({ children, element }) => (
    <p style={element.align ? { textAlign: element.align } : undefined}>
      {children}
    </p>
  ),
});
```

**Props**:
| Property        | Type                              | Description    |
|-----------------|-----------------------------------|----------------|
| `children`      | `any`                             | Child elements |
| `element.align` | `'left' \| 'center' \| 'right'`  | Alignment      |

**Default output**: `<p className="qdr-paragraph">{children}</p>`

---

### LineBreak

```typescript
import { createJsxSerializeLineBreak } from '@quadrats/react/line-break/jsx-serializer';

const lineBreakSerializer = createJsxSerializeLineBreak({
  render: () => <br />,
});
```

**Default output**: `<br />`

---

### Heading

```typescript
import { createJsxSerializeHeading } from '@quadrats/react/heading/jsx-serializer';

const headingSerializer = createJsxSerializeHeading({
  type: 'heading',  // Can override the type
  render: ({ children, element }) => {
    const Tag = `h${element.level}` as keyof JSX.IntrinsicElements;
    return <Tag>{children}</Tag>;
  },
});
```

**Props**:
| Property        | Type                              | Description      |
|-----------------|-----------------------------------|------------------|
| `element.level` | `1 \| 2 \| 3 \| 4 \| 5 \| 6`    | Heading level    |
| `element.align` | `'left' \| 'center' \| 'right'`  | Alignment        |

**Default output**: `<h1>` ~ `<h6>` (based on level)

---

### Blockquote

```typescript
import { createJsxSerializeBlockquote } from '@quadrats/react/blockquote/jsx-serializer';

const blockquoteSerializer = createJsxSerializeBlockquote({
  render: ({ children }) => (
    <blockquote className="qdr-blockquote">{children}</blockquote>
  ),
});
```

**Default output**: `<blockquote className="qdr-blockquote">{children}</blockquote>`

---

### Divider

```typescript
import { createJsxSerializeDivider } from '@quadrats/react/divider/jsx-serializer';

const dividerSerializer = createJsxSerializeDivider({
  render: () => <hr className="qdr-divider" />,
});
```

**Default output**: `<hr className="qdr-divider" />`

---

## Lists and Tables

### List

```typescript
import { createJsxSerializeList } from '@quadrats/react/list/jsx-serializer';

const listSerializer = createJsxSerializeList({
  ol: {
    type: 'ol',
    render: ({ children }) => <ol>{children}</ol>,
  },
  ul: {
    type: 'ul',
    render: ({ children }) => <ul>{children}</ul>,
  },
  li: {
    type: 'li',
    render: ({ children }) => <li>{children}</li>,
  },
});
```

**Configurable elements**:
| Key  | Type           | Default Output          |
|------|----------------|-------------------------|
| `ol` | Ordered list   | `<ol>{children}</ol>`   |
| `ul` | Unordered list | `<ul>{children}</ul>`   |
| `li` | List item      | `<li>{children}</li>`   |

---

### Table

```typescript
import { createJsxSerializeTable } from '@quadrats/react/table/jsx-serializer';

const tableSerializer = createJsxSerializeTable({
  table: {
    render: ({ children }) => (
      <table className="qdr-table">{children}</table>
    ),
  },
  table_title: {
    render: ({ children }) => <caption>{children}</caption>,
  },
  table_main: {
    render: ({ children }) => <>{children}</>,
  },
  table_header: {
    render: ({ children }) => <thead>{children}</thead>,
  },
  table_body: {
    render: ({ children }) => <tbody>{children}</tbody>,
  },
  table_row: {
    render: ({ children }) => <tr>{children}</tr>,
  },
  table_cell: {
    render: ({ children, element }) => {
      const Tag = element.header ? 'th' : 'td';
      return <Tag>{children}</Tag>;
    },
  },
});
```

**Configurable elements**:
| Key            | Type            | Default Output    |
|----------------|-----------------|-------------------|
| `table`        | Table container | `<table>`         |
| `table_title`  | Title           | `<caption>`       |
| `table_main`   | Main container  | Fragment          |
| `table_header` | Header          | `<thead>`         |
| `table_body`   | Body            | `<tbody>`         |
| `table_row`    | Row             | `<tr>`            |
| `table_cell`   | Cell            | `<td>` or `<th>`  |

---

## Media Elements

### Image

```typescript
import { createJsxSerializeImage } from '@quadrats/react/image/jsx-serializer';

const imageSerializer = createJsxSerializeImage({
  figure: {
    render: ({ children, style }) => (
      <figure className="qdr-image__figure" style={style}>
        {children}
      </figure>
    ),
  },
  image: {
    render: ({ src, caption }) => (
      <div className="qdr-image">
        <img src={src} alt={caption} />
      </div>
    ),
  },
  caption: {
    render: ({ children, isEmpty }) =>
      isEmpty ? null : (
        <figcaption className="qdr-image__caption">{children}</figcaption>
      ),
  },
  // Image hosting resolvers (optional)
  hostingResolvers: {
    gcs: (src) => `https://storage.googleapis.com/${src}`,
    // Other hosting services...
  },
});
```

**Configurable elements**:
| Key       | Props                  | Description       |
|-----------|------------------------|-------------------|
| `figure`  | `{ children, style }` | Image container   |
| `image`   | `{ src, caption }`    | Image element     |
| `caption` | `{ children, isEmpty }`| Image caption    |

**hostingResolvers**:
Used to transform image URLs, e.g. converting relative paths to CDN paths.

---

### Carousel

```typescript
import { createJsxSerializeCarousel } from '@quadrats/react/carousel/jsx-serializer';

const carouselSerializer = createJsxSerializeCarousel();
```

---

### Card

```typescript
import { createJsxSerializeCard } from '@quadrats/react/card/jsx-serializer';

const cardSerializer = createJsxSerializeCard();
```

---

### Embed

```typescript
import { createJsxSerializeEmbed } from '@quadrats/react/embed/jsx-serializer';
import { YoutubeEmbedStrategy } from '@quadrats/common/embed/strategies/youtube';
import { VimeoEmbedStrategy } from '@quadrats/common/embed/strategies/vimeo';
import {
  defaultRenderYoutubeEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/youtube';
import {
  defaultRenderVimeoEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/vimeo';

const embedSerializer = createJsxSerializeEmbed({
  strategies: {
    youtube: YoutubeEmbedStrategy,
    vimeo: VimeoEmbedStrategy,
  },
  renderers: {
    youtube: defaultRenderYoutubeEmbedJsxSerializer,
    vimeo: defaultRenderVimeoEmbedJsxSerializer,
  },
});
```

**Parameters**:
| Parameter    | Type                         | Description                          |
|--------------|------------------------------|--------------------------------------|
| `strategies` | `EmbedStrategies`            | Embed strategies (same as editor)    |
| `renderers`  | `Record<string, Renderer>`   | Render functions for each platform   |

**Available renderers**:

| Platform      | Package                                           | Function                                        |
|---------------|---------------------------------------------------|-------------------------------------------------|
| YouTube       | `@quadrats/react/embed/renderers/youtube`         | `defaultRenderYoutubeEmbedJsxSerializer`        |
| Vimeo         | `@quadrats/react/embed/renderers/vimeo`           | `defaultRenderVimeoEmbedJsxSerializer`          |
| Instagram     | `@quadrats/react/embed/renderers/instagram`       | `defaultRenderInstagramEmbedJsxSerializer`      |
| Facebook      | `@quadrats/react/embed/renderers/facebook`        | `defaultRenderFacebookEmbedJsxSerializer`       |
| Twitter       | `@quadrats/react/embed/renderers/twitter`         | `defaultRenderTwitterEmbedJsxSerializer`        |
| Spotify       | `@quadrats/react/embed/renderers/spotify`         | `defaultRenderSpotifyEmbedJsxSerializer`        |
| Apple Podcast | `@quadrats/react/embed/renderers/podcast-apple`   | `defaultRenderPodcastAppleEmbedJsxSerializer`   |

---

## Special Elements

### Link

```typescript
import { createJsxSerializeLink } from '@quadrats/react/link/jsx-serializer';

const linkSerializer = createJsxSerializeLink({
  render: ({ children, element }) => (
    <a
      href={element.url}
      target="_blank"
      rel="noopener noreferrer"
      className="qdr-link"
    >
      {children}
    </a>
  ),
});
```

**Props**:
| Property      | Type     | Description |
|---------------|----------|-------------|
| `element.url` | `string` | Link URL    |

**Default output**: `<a target="_blank" className="qdr-link">{children}</a>`

---

### Footnote

```typescript
import { createJsxSerializeFootnote } from '@quadrats/react/footnote/jsx-serializer';

const footnoteSerializer = createJsxSerializeFootnote({
  render: ({ children, element }) => (
    <span className="qdr-footnote" data-footnote-id={element.id}>
      {children}
    </span>
  ),
});
```

---

### ReadMore

```typescript
import { createJsxSerializeReadMore } from '@quadrats/react/read-more/jsx-serializer';

const readMoreSerializer = createJsxSerializeReadMore({
  render: () => (
    <div className="qdr-read-more">
      <hr />
      <span>Read More</span>
    </div>
  ),
});
```

---

### Accordion

```typescript
import { createJsxSerializeAccordion } from '@quadrats/react/accordion/jsx-serializer';

const accordionSerializer = createJsxSerializeAccordion();
```

---

## Custom Element Serializers

Use the low-level API to create fully custom serializers:

```typescript
import { createJsxSerializeElement } from '@quadrats/react/jsx-serializer';

interface MyCustomElementProps {
  children: any;
  element: {
    type: 'my-custom';
    customProp: string;
  };
}

const myCustomSerializer = createJsxSerializeElement<MyCustomElementProps>({
  type: 'my-custom',
  render: ({ children, element }) => (
    <div className="my-custom" data-custom={element.customProp}>
      {children}
    </div>
  ),
});

// Multi-element serializer
import { createJsxSerializeElements } from '@quadrats/react/jsx-serializer';

const multiSerializer = createJsxSerializeElements([
  { type: 'type-a', render: (props) => <div>{props.children}</div> },
  { type: 'type-b', render: (props) => <span>{props.children}</span> },
]);
```
