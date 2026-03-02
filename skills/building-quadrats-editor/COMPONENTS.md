# Quadrats Component Full Parameter Reference

## Mark Components

Mark components handle text formatting and render via `createRenderLeaf()`.

### Bold

```typescript
import { createReactBold } from '@quadrats/react/bold';

const bold = createReactBold(variant?: string);

// variant: optional variant name for custom styling
```

| Method                    | Description                      |
|---------------------------|----------------------------------|
| `bold.createRenderLeaf()` | Create leaf renderer            |
| `bold.createHandlers()`   | Create keyboard handler (Mod+B) |
| `bold.toggleMark(editor)` | Programmatically toggle bold    |

---

### Italic

```typescript
import { createReactItalic } from '@quadrats/react/italic';

const italic = createReactItalic(variant?: string);
```

| Method                      | Description                       |
|-----------------------------|-----------------------------------|
| `italic.createRenderLeaf()` | Create leaf renderer             |
| `italic.createHandlers()`   | Create keyboard handler (Mod+I) |
| `italic.toggleMark(editor)` | Programmatically toggle italic   |

---

### Underline

```typescript
import { createReactUnderline } from '@quadrats/react/underline';

const underline = createReactUnderline(variant?: string);
```

| Method                         | Description                        |
|--------------------------------|------------------------------------|
| `underline.createRenderLeaf()` | Create leaf renderer              |
| `underline.createHandlers()`   | Create keyboard handler (Mod+U)  |
| `underline.toggleMark(editor)` | Programmatically toggle underline |

---

### Strikethrough

```typescript
import { createReactStrikethrough } from '@quadrats/react/strikethrough';

const strikethrough = createReactStrikethrough(variant?: string);
```

| Method                             | Description                              |
|------------------------------------|------------------------------------------|
| `strikethrough.createRenderLeaf()` | Create leaf renderer                    |
| `strikethrough.createHandlers()`   | Create keyboard handler (Mod+Shift+X)  |
| `strikethrough.toggleMark(editor)` | Programmatically toggle strikethrough   |

---

### Highlight

```typescript
import { createReactHighlight } from '@quadrats/react/highlight';

// Default highlight
const highlight = createReactHighlight();

// Custom variants (for different colors/styles)
const sheetMusic = createReactHighlight('sheet-music');
const drama = createReactHighlight('drama');
```

| Method                         | Description                             |
|--------------------------------|-----------------------------------------|
| `highlight.createRenderLeaf()` | Create leaf renderer                   |
| `highlight.createHandlers()`   | Create keyboard handler (Mod+Shift+H) |
| `highlight.toggleMark(editor)` | Programmatically toggle highlight      |

**CSS class**: Variants generate a `highlight.{variant}` class

---

## Block Components

Block components require the `.with` editor extension and render via `createRenderElement()`.

### Paragraph

```typescript
import { createReactParagraph, renderParagraphElementWithSymbol } from '@quadrats/react/paragraph';

const paragraph = createReactParagraph();

// Use the symbol renderer (displays the paragraph symbol)
paragraph.createRenderElement({
  render: renderParagraphElementWithSymbol,
});
```

| Method                              | Description             |
|-------------------------------------|-------------------------|
| `paragraph.createRenderElement()`   | Create element renderer |
| `paragraph.toggleParagraph(editor)` | Convert to paragraph    |

---

### Heading

```typescript
import { createReactHeading } from '@quadrats/react/heading';
import { HeadingLevel } from '@quadrats/common/heading';

const heading = createReactHeading({
  enabledLevels: [1, 2, 3] as HeadingLevel[],  // Enable only h1, h2, h3
});

// Enable all heading levels
const headingAll = createReactHeading({
  enabledLevels: [1, 2, 3, 4, 5, 6],
});
```

**Parameters**:
| Parameter       | Type             | Description                     |
|-----------------|------------------|---------------------------------|
| `enabledLevels` | `HeadingLevel[]` | Enabled heading levels (1 - 6) |

| Method                                  | Description                         |
|-----------------------------------------|-------------------------------------|
| `heading.with`                          | Editor extension                    |
| `heading.createRenderElement()`         | Create element renderer             |
| `heading.createHandlers()`              | Create keyboard handler (Mod+1~6)  |
| `heading.toggleHeading(editor, level)`  | Toggle specified heading level      |

---

### LineBreak (Soft Break)

```typescript
import { createReactLineBreak, renderLineBreakElementWithSymbol } from '@quadrats/react/line-break';

const lineBreak = createReactLineBreak();

// Display line break symbol
lineBreak.createRenderElement({
  render: renderLineBreakElementWithSymbol,
});
```

| Method                              | Description                               |
|-------------------------------------|-------------------------------------------|
| `lineBreak.with`                    | Editor extension (MUST include)           |
| `lineBreak.createRenderElement()`   | Create element renderer                   |
| `lineBreak.createHandlers()`        | Create keyboard handler (Shift+Enter)     |

---

### Blockquote

```typescript
import { createReactBlockquote } from '@quadrats/react/blockquote';

const blockquote = createReactBlockquote();
```

| Method                                            | Description                            |
|---------------------------------------------------|----------------------------------------|
| `blockquote.with`                                 | Editor extension                       |
| `blockquote.createRenderElement()`                | Create element renderer                |
| `blockquote.createHandlers()`                     | Create keyboard handler (Mod+')        |
| `blockquote.toggleBlockquote(editor)`             | Toggle blockquote                      |
| `blockquote.isSelectionInBlockquote(editor)`      | Check if cursor is inside a blockquote |

---

### Divider

```typescript
import { createReactDivider } from '@quadrats/react/divider';

const divider = createReactDivider();
```

| Method                           | Description             |
|----------------------------------|-------------------------|
| `divider.with`                   | Editor extension        |
| `divider.createRenderElement()`  | Create element renderer |
| `divider.insertDivider(editor)`  | Insert a divider        |

---

### List

```typescript
import { createReactList } from '@quadrats/react/list';

const list = createReactList();
```

| Method                            | Description                         |
|-----------------------------------|-------------------------------------|
| `list.with`                       | Editor extension                    |
| `list.createRenderElement()`      | Create element renderer             |
| `list.createHandlers()`           | Create keyboard handler (Tab indent)|
| `list.toggleList(editor, 'ol')`   | Toggle ordered list                 |
| `list.toggleList(editor, 'ul')`   | Toggle unordered list               |

**Keyboard operations**:
- `Tab`: Increase indent level
- `Shift+Tab`: Decrease indent level
- Up to 6 levels of nesting supported

---

### Table

```typescript
import { createReactTable } from '@quadrats/react/table';

const table = createReactTable();
```

| Method                                    | Description                |
|-------------------------------------------|----------------------------|
| `table.with`                              | Editor extension           |
| `table.createRenderElement()`             | Create element renderer    |
| `table.createHandlers()`                  | Create keyboard handler    |
| `table.insertTable(editor, rows, cols)`   | Insert a table             |

**Keyboard operations**:
- `Enter`: Insert line break if cell has content; jump to next cell if empty
- `Tab`: Jump to next cell
- `Arrow Up/Down`: Move across rows

---

### Accordion

```typescript
import { createReactAccordion } from '@quadrats/react/accordion';

const accordion = createReactAccordion();
```

| Method                                 | Description             |
|----------------------------------------|-------------------------|
| `accordion.with`                       | Editor extension        |
| `accordion.createRenderElement()`      | Create element renderer |
| `accordion.createHandlers()`           | Create keyboard handler |
| `accordion.insertAccordion(editor)`    | Insert an accordion     |

---

## Media Components

### Image

```typescript
import { createReactImage, ImagePlaceholder } from '@quadrats/react/image';
import { createReactFileUploader } from '@quadrats/react/file-uploader';

const image = createReactImage(
  {
    sizeSteps: [25, 50, 75],  // Size adjustment steps (percentage)
  },
  (img) => ({
    // Upload options
    getBody: (file) => file,
    getHeaders: (file) => ({
      'Authorization': 'Bearer <token>',
      'Content-Type': file.type,
    }),
    getUrl: (file) => `https://api.example.com/upload/${file.name}`,
  }),
);

// Use with FileUploader
const fileUploader = createReactFileUploader();
```

**CreateImageOptions**:
| Parameter          | Type       | Description                          |
|--------------------|------------|--------------------------------------|
| `sizeSteps`        | `number[]` | Size adjustment steps (default `[25, 50, 75]`) |
| `hostingResolvers` | `object`   | Image hosting resolvers              |

**FileUploaderUploadOptions**:
| Parameter    | Type                | Description          |
|--------------|---------------------|----------------------|
| `getBody`    | `(file) => any`     | Get request body     |
| `getHeaders` | `(file) => object`  | Get request headers  |
| `getUrl`     | `(file) => string`  | Get upload URL       |
| `type`       | `string`            | Uploader type (optional) |

| Method                                       | Description                         |
|----------------------------------------------|-------------------------------------|
| `image.with`                                 | Editor extension                    |
| `image.createRenderElement()`                | Create element renderer             |
| `image.createHandlers()`                     | Create keyboard handler             |
| `image.insertImage(editor, url)`             | Insert an image                     |
| `image.isSelectionInImageCaption(editor)`    | Check if cursor is in image caption |
| `image.isCollapsedOnImage(editor)`           | Check if cursor is on an image      |
| `image.resizeImage(editor, size)`            | Resize image                        |

**Renderer options**:
```typescript
image.createRenderElement({
  figure: (props) => <figure {...props.attributes}>{props.children}</figure>,
  image: (props) => <img src={props.src} alt={props.caption} />,
  caption: (props) => <figcaption>{props.children}</figcaption>,
});

// With placeholder
fileUploader.createRenderPlaceholderElement({
  render: (props) => <ImagePlaceholder {...props} />,
});
```

---

### Carousel

```typescript
import { createReactCarousel } from '@quadrats/react/carousel';

const carousel = createReactCarousel({
  ratio: [16, 9],              // Aspect ratio
  maxLength: 12,               // Maximum number of items
  limitSize: 2,                // File size limit (MB)
  getBody: (file) => file,
  getHeaders: (file) => ({
    'Authorization': 'Bearer <token>',
    'Content-Type': file.type,
  }),
  getUrl: (file) => `https://api.example.com/upload/${file.name}`,
  uploader: yourFileUploader,  // Uploader instance
});
```

**Parameters**:
| Parameter    | Type                | Default    | Description           |
|--------------|---------------------|------------|-----------------------|
| `ratio`      | `[number, number]`  | `[16, 9]`  | Aspect ratio         |
| `maxLength`  | `number`            | `12`        | Maximum item count   |
| `limitSize`  | `number`            | `2`         | File size limit (MB) |
| `getBody`    | `(file) => any`     | -           | Get request body     |
| `getHeaders` | `(file) => object`  | -           | Get request headers  |
| `getUrl`     | `(file) => string`  | -           | Get upload URL       |
| `uploader`   | `FileUploader`      | -           | Uploader instance    |

| Method                                                    | Description                    |
|-----------------------------------------------------------|--------------------------------|
| `carousel.with`                                           | Editor extension               |
| `carousel.createRenderElement()`                          | Create element renderer        |
| `carousel.createRenderPlaceholderElement()`               | Create placeholder renderer    |
| `carousel.createHandlers(setConfirmModal, locale)`        | Create event handlers          |
| `carousel.insertCarousel(editor)`                         | Insert a carousel              |

---

### Card

```typescript
import { createReactCard } from '@quadrats/react/card';

const card = createReactCard({
  ratio: [3, 2],               // Aspect ratio
  limitSize: 2,                // File size limit (MB)
  getBody: (file) => file,
  getHeaders: (file) => ({ ... }),
  getUrl: (file) => `https://api.example.com/upload/${file.name}`,
  uploader: yourFileUploader,
});
```

**Parameters**: Same as Carousel

| Method                                               | Description                 |
|------------------------------------------------------|-----------------------------|
| `card.with`                                          | Editor extension            |
| `card.createRenderElement()`                         | Create element renderer     |
| `card.createRenderPlaceholderElement()`               | Create placeholder renderer |
| `card.createHandlers(setConfirmModal, locale)`       | Create event handlers       |
| `card.insertCard(editor)`                            | Insert a card               |

---

### Embed

```typescript
import { createReactEmbed } from '@quadrats/react/embed';
import { YoutubeEmbedStrategy } from '@quadrats/common/embed/strategies/youtube';
import { VimeoEmbedStrategy } from '@quadrats/common/embed/strategies/vimeo';
import { InstagramEmbedStrategy } from '@quadrats/common/embed/strategies/instagram';
import { FacebookEmbedStrategy } from '@quadrats/common/embed/strategies/facebook';
import { TwitterEmbedStrategy } from '@quadrats/common/embed/strategies/twitter';
import { SpotifyEmbedStrategy } from '@quadrats/common/embed/strategies/spotify';
import { PodcastAppleEmbedStrategy } from '@quadrats/common/embed/strategies/podcast-apple';

const embed = createReactEmbed({
  strategies: {
    youtube: YoutubeEmbedStrategy,
    vimeo: VimeoEmbedStrategy,
    instagram: InstagramEmbedStrategy,
    facebook: FacebookEmbedStrategy,
    twitter: TwitterEmbedStrategy,
    spotify: SpotifyEmbedStrategy,
    podcastApple: PodcastAppleEmbedStrategy,
  },
});
```

**Available strategies**:
| Strategy                     | Package                                              | Supported Site  |
|------------------------------|------------------------------------------------------|-----------------|
| `YoutubeEmbedStrategy`       | `@quadrats/common/embed/strategies/youtube`          | YouTube         |
| `VimeoEmbedStrategy`         | `@quadrats/common/embed/strategies/vimeo`            | Vimeo           |
| `InstagramEmbedStrategy`     | `@quadrats/common/embed/strategies/instagram`        | Instagram       |
| `FacebookEmbedStrategy`      | `@quadrats/common/embed/strategies/facebook`         | Facebook        |
| `TwitterEmbedStrategy`       | `@quadrats/common/embed/strategies/twitter`          | Twitter/X       |
| `SpotifyEmbedStrategy`       | `@quadrats/common/embed/strategies/spotify`          | Spotify         |
| `PodcastAppleEmbedStrategy`  | `@quadrats/common/embed/strategies/podcast-apple`    | Apple Podcast   |

| Method                                             | Description                    |
|----------------------------------------------------|--------------------------------|
| `embed.with`                                       | Editor extension               |
| `embed.createRenderElement(renderers)`             | Create element renderer        |
| `embed.createRenderPlaceholderElement(renderers)`  | Create placeholder renderer    |
| `embed.insertEmbed(editor, provider, url)`         | Insert embedded content        |

**Renderers**:
```typescript
import {
  defaultRenderYoutubeEmbedElement,
  defaultRenderYoutubeEmbedPlaceholderElement,
} from '@quadrats/react/embed/renderers/youtube';

embed.createRenderElement({
  youtube: defaultRenderYoutubeEmbedElement,
  vimeo: defaultRenderVimeoEmbedElement,
  // ...
});
```

---

## Special Components

### Link

```typescript
import { createReactLink } from '@quadrats/react/link';

const link = createReactLink({
  pastedUrlToLink: true,                        // Auto-convert pasted URLs
  wrappableVoidTypes: [image.types.image],     // Void types that can be wrapped with links
});
```

**Parameters**:
| Parameter            | Type       | Default | Description                              |
|----------------------|------------|---------|------------------------------------------|
| `pastedUrlToLink`    | `boolean`  | `true`  | Auto-convert pasted URLs to links        |
| `wrappableVoidTypes` | `string[]` | `[]`    | Void element types that can wrap in links |

| Method                          | Description                         |
|---------------------------------|-------------------------------------|
| `link.with`                     | Editor extension                    |
| `link.createRenderElement()`    | Create element renderer             |
| `link.insertLink(editor, url)`  | Insert a link                       |
| `link.unwrapLink(editor)`       | Remove a link                       |
| `link.isLinkActive(editor)`     | Check if cursor is on a link        |

---

### Footnote

```typescript
import { createReactFootnote } from '@quadrats/react/footnote';

const footnote = createReactFootnote();
```

| Method                              | Description             |
|-------------------------------------|-------------------------|
| `footnote.with`                     | Editor extension        |
| `footnote.createRenderElement()`    | Create element renderer |
| `footnote.insertFootnote(editor)`   | Insert a footnote       |

---

### ReadMore

```typescript
import { createReactReadMore } from '@quadrats/react/read-more';

const readMore = createReactReadMore();
```

| Method                              | Description                    |
|-------------------------------------|--------------------------------|
| `readMore.with`                     | Editor extension               |
| `readMore.createRenderElement()`    | Create element renderer        |
| `readMore.insertReadMore(editor)`   | Insert a read-more separator   |

---

### Align

```typescript
import { createReactAlign } from '@quadrats/react/align';

const align = createReactAlign({
  hotkeys: {
    left: 'mod+shift+l',
    center: 'mod+shift+e',
    right: 'mod+shift+r',
  },
});
```

**Parameters**:
| Parameter        | Type     | Default          | Description           |
|------------------|----------|------------------|-----------------------|
| `hotkeys.left`   | `string` | `'mod+shift+l'`  | Left-align hotkey    |
| `hotkeys.center` | `string` | `'mod+shift+e'`  | Center-align hotkey  |
| `hotkeys.right`  | `string` | `'mod+shift+r'`  | Right-align hotkey   |

| Method                              | Description          |
|-------------------------------------|----------------------|
| `align.createHandlers()`            | Create keyboard handler |
| `align.setAlign(editor, 'left')`    | Set left alignment   |
| `align.setAlign(editor, 'center')`  | Set center alignment |
| `align.setAlign(editor, 'right')`   | Set right alignment  |

---

### InputBlock

```typescript
import { createReactInputBlock } from '@quadrats/react/input-block';

const inputBlock = createReactInputBlock();
```

| Method                               | Description                        |
|--------------------------------------|------------------------------------|
| `inputBlock.with`                    | Editor extension (recommended)     |
| `inputBlock.createRenderElement()`   | Create element renderer            |

---

## Component Composition Pattern

### Complete Editor Composition Example

```typescript
import { pipe } from '@quadrats/utils';
import { createReactEditor, composeRenderElements, composeRenderLeafs, composeHandlers } from '@quadrats/react';

// 1. Create all components
const paragraph = createReactParagraph();
const lineBreak = createReactLineBreak();
const heading = createReactHeading({ enabledLevels: [1, 2, 3] });
const bold = createReactBold();
const italic = createReactItalic();
const image = createReactImage({ sizeSteps: [25, 50, 75] });
const link = createReactLink({ wrappableVoidTypes: [image.types.image] });

// 2. Compose editor (using .with)
const editor = pipe(
  createReactEditor(),
  lineBreak.with,
  heading.with,
  image.with,
  link.with,
);

// 3. Compose element renderers
const renderElement = composeRenderElements([
  paragraph.createRenderElement(),
  lineBreak.createRenderElement(),
  heading.createRenderElement(),
  image.createRenderElement(),
  link.createRenderElement(),
]);

// 4. Compose mark renderers
const renderLeaf = composeRenderLeafs([
  bold.createRenderLeaf(),
  italic.createRenderLeaf(),
]);

// 5. Compose event handlers
const handlers = composeHandlers([
  lineBreak.createHandlers(),
  heading.createHandlers(),
  bold.createHandlers(),
  italic.createHandlers(),
  image.createHandlers(),
])(editor);
```
