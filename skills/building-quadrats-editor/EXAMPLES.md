# Quadrats Editor Complete Examples

## Basic Blog Editor

Suitable for general blog post editing:

```typescript
import React, { useState, useMemo, useCallback } from 'react';
import { pipe } from '@quadrats/utils';
import {
  Quadrats,
  Editable,
  createReactEditor,
  composeRenderElements,
  composeRenderLeafs,
  composeHandlers,
  Descendant,
} from '@quadrats/react';
import { ConfigsProvider } from '@quadrats/react/configs';
import { zhTW } from '@quadrats/locales';
import { PARAGRAPH_TYPE } from '@quadrats/core';

// Components
import { createReactParagraph } from '@quadrats/react/paragraph';
import { createReactLineBreak } from '@quadrats/react/line-break';
import { createReactHeading } from '@quadrats/react/heading';
import { createReactBold } from '@quadrats/react/bold';
import { createReactItalic } from '@quadrats/react/italic';
import { createReactLink } from '@quadrats/react/link';
import { createReactBlockquote } from '@quadrats/react/blockquote';
import { createReactDivider } from '@quadrats/react/divider';
import { createReactList } from '@quadrats/react/list';

// Toolbar
import { Toolbar, TOOLBAR_DIVIDER } from '@quadrats/react/toolbar';
import { ToggleMarkToolbarIcon } from '@quadrats/react/toggle-mark/toolbar';
import { ParagraphToolbarIcon } from '@quadrats/react/paragraph/toolbar';
import { HeadingToolbarIcon } from '@quadrats/react/heading/toolbar';
import { LinkToolbarIcon, UnlinkToolbarIcon } from '@quadrats/react/link/toolbar';
import { BlockquoteToolbarIcon } from '@quadrats/react/blockquote/toolbar';
import { DividerToolbarIcon } from '@quadrats/react/divider/toolbar';
import { ListToolbarIcon } from '@quadrats/react/list/toolbar';

// Icons
import {
  Bold as BoldIcon,
  Italic as ItalicIcon,
  Link as LinkIcon,
  Unlink as UnlinkIcon,
  Paragraph as ParagraphIcon,
  Heading1 as Heading1Icon,
  Heading2 as Heading2Icon,
  Heading3 as Heading3Icon,
  Blockquote as BlockquoteIcon,
  Divider as DividerIcon,
  UnorderedList as UnorderedListIcon,
  OrderedList as OrderedListIcon,
} from '@quadrats/icons';

// Create components
const paragraph = createReactParagraph();
const lineBreak = createReactLineBreak();
const heading = createReactHeading({ enabledLevels: [1, 2, 3] });
const bold = createReactBold();
const italic = createReactItalic();
const link = createReactLink();
const blockquote = createReactBlockquote();
const divider = createReactDivider();
const list = createReactList();

export function BlogEditor() {
  // Compose editor
  const editor = useMemo(
    () =>
      pipe(
        createReactEditor(),
        lineBreak.with,
        heading.with,
        link.with,
        blockquote.with,
        divider.with,
        list.with,
      ),
    [],
  );

  // Compose renderers
  const renderElement = useMemo(
    () =>
      composeRenderElements([
        paragraph.createRenderElement(),
        lineBreak.createRenderElement(),
        heading.createRenderElement(),
        link.createRenderElement(),
        blockquote.createRenderElement(),
        divider.createRenderElement(),
        list.createRenderElement(),
      ]),
    [],
  );

  const renderLeaf = useMemo(
    () =>
      composeRenderLeafs([
        bold.createRenderLeaf(),
        italic.createRenderLeaf(),
      ]),
    [],
  );

  // Compose event handlers
  const handlers = useMemo(
    () =>
      composeHandlers([
        lineBreak.createHandlers(),
        heading.createHandlers(),
        blockquote.createHandlers(),
        list.createHandlers(),
        bold.createHandlers(),
        italic.createHandlers(),
      ])(editor),
    [editor],
  );

  // Toolbar renderer
  const toolbarRenderer = useCallback(
    (expanded: boolean) => {
      if (expanded) {
        return (
          <>
            <ToggleMarkToolbarIcon icon={BoldIcon} controller={bold} />
            <ToggleMarkToolbarIcon icon={ItalicIcon} controller={italic} />
            <LinkToolbarIcon icon={LinkIcon} controller={link} />
            <UnlinkToolbarIcon icon={UnlinkIcon} controller={link} />
          </>
        );
      }

      return (
        <>
          <ParagraphToolbarIcon icon={ParagraphIcon} controller={paragraph} />
          <HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
          <HeadingToolbarIcon icon={Heading2Icon} controller={heading} level={2} />
          <HeadingToolbarIcon icon={Heading3Icon} controller={heading} level={3} />
          <BlockquoteToolbarIcon icon={BlockquoteIcon} controller={blockquote} />
          {TOOLBAR_DIVIDER}
          <ListToolbarIcon icon={UnorderedListIcon} controller={list} listTypeKey="ul" />
          <ListToolbarIcon icon={OrderedListIcon} controller={list} listTypeKey="ol" />
          {TOOLBAR_DIVIDER}
          <DividerToolbarIcon icon={DividerIcon} controller={divider} />
        </>
      );
    },
    [],
  );

  // Initial value
  const [value, setValue] = useState<Descendant[]>([
    { type: PARAGRAPH_TYPE, children: [{ text: '' }] },
  ]);

  return (
    <ConfigsProvider locale={zhTW} theme="light">
      <Quadrats editor={editor} value={value} onChange={setValue}>
        <Toolbar fixed>{toolbarRenderer}</Toolbar>
        <Toolbar onlyRenderExpanded>{toolbarRenderer}</Toolbar>
        <Editable
          {...handlers}
          renderElement={renderElement}
          renderLeaf={renderLeaf}
          placeholder="Start writing..."
        />
      </Quadrats>
    </ConfigsProvider>
  );
}
```

---

## Media-Rich Editor

Supports image and video embedding:

```typescript
import React, { useState, useMemo, useCallback } from 'react';
import { pipe } from '@quadrats/utils';
import {
  Quadrats,
  Editable,
  createReactEditor,
  composeRenderElements,
  composeRenderLeafs,
  composeHandlers,
  Descendant,
  ConfirmModalConfig,
} from '@quadrats/react';
import { ConfigsProvider } from '@quadrats/react/configs';
import { zhTW } from '@quadrats/locales';
import { PARAGRAPH_TYPE } from '@quadrats/core';

// Basic components
import { createReactParagraph } from '@quadrats/react/paragraph';
import { createReactLineBreak } from '@quadrats/react/line-break';
import { createReactHeading } from '@quadrats/react/heading';
import { createReactBold } from '@quadrats/react/bold';
import { createReactItalic } from '@quadrats/react/italic';
import { createReactLink } from '@quadrats/react/link';

// Media components
import { createReactImage, ImagePlaceholder } from '@quadrats/react/image';
import { createReactFileUploader } from '@quadrats/react/file-uploader';
import { createReactEmbed } from '@quadrats/react/embed';
import { createReactCarousel } from '@quadrats/react/carousel';
import { YoutubeEmbedStrategy } from '@quadrats/common/embed/strategies/youtube';
import { VimeoEmbedStrategy } from '@quadrats/common/embed/strategies/vimeo';
import {
  defaultRenderYoutubeEmbedElement,
  defaultRenderYoutubeEmbedPlaceholderElement,
} from '@quadrats/react/embed/renderers/youtube';
import {
  defaultRenderVimeoEmbedElement,
  defaultRenderVimeoEmbedPlaceholderElement,
} from '@quadrats/react/embed/renderers/vimeo';

// Toolbar
import { Toolbar, TOOLBAR_DIVIDER } from '@quadrats/react/toolbar';
import { ToggleMarkToolbarIcon } from '@quadrats/react/toggle-mark/toolbar';
import { HeadingToolbarIcon } from '@quadrats/react/heading/toolbar';
import { LinkToolbarIcon } from '@quadrats/react/link/toolbar';
import { FileUploaderToolbarIcon } from '@quadrats/react/file-uploader/toolbar';
import { EmbedToolbarIcon } from '@quadrats/react/embed/toolbar';
import { CarouselToolbarIcon } from '@quadrats/react/carousel/toolbar';

// Icons
import {
  Bold as BoldIcon,
  Italic as ItalicIcon,
  Link as LinkIcon,
  Heading1 as Heading1Icon,
  Heading2 as Heading2Icon,
  Image as ImageIcon,
  Youtube as YoutubeIcon,
  Vimeo as VimeoIcon,
  Carousel as CarouselIcon,
} from '@quadrats/icons';

// Upload options
const getUploadOptions = (image: any) => ({
  getBody: (file: File) => file,
  getHeaders: (file: File) => ({
    'Content-Type': file.type,
  }),
  getUrl: (file: File) => `/api/upload/${file.name}`,
});

// Create components
const paragraph = createReactParagraph();
const lineBreak = createReactLineBreak();
const heading = createReactHeading({ enabledLevels: [1, 2] });
const bold = createReactBold();
const italic = createReactItalic();
const fileUploader = createReactFileUploader();

const image = createReactImage(
  { sizeSteps: [25, 50, 75] },
  getUploadOptions,
);

const link = createReactLink({
  wrappableVoidTypes: [image.types.image],
});

const embed = createReactEmbed({
  strategies: {
    youtube: YoutubeEmbedStrategy,
    vimeo: VimeoEmbedStrategy,
  },
});

const carousel = createReactCarousel({
  ratio: [16, 9],
  maxLength: 12,
  limitSize: 5,
  getBody: (file) => file,
  getHeaders: (file) => ({ 'Content-Type': file.type }),
  getUrl: (file) => `/api/upload/${file.name}`,
  // uploader: yourFileUploader,
});

export function MediaRichEditor() {
  const [needConfirmModal, setNeedConfirmModal] = useState<ConfirmModalConfig | null>(null);

  const editor = useMemo(
    () =>
      pipe(
        createReactEditor(),
        lineBreak.with,
        heading.with,
        link.with,
        image.with,
        fileUploader.with,
        embed.with,
        carousel.with,
      ),
    [],
  );

  const renderElement = useMemo(
    () =>
      composeRenderElements([
        paragraph.createRenderElement(),
        lineBreak.createRenderElement(),
        heading.createRenderElement(),
        link.createRenderElement(),
        image.createRenderElement(),
        fileUploader.createRenderElement(),
        fileUploader.createRenderPlaceholderElement({
          render: (props) => <ImagePlaceholder {...props} />,
        }),
        embed.createRenderElement({
          youtube: defaultRenderYoutubeEmbedElement,
          vimeo: defaultRenderVimeoEmbedElement,
        }),
        embed.createRenderPlaceholderElement({
          youtube: defaultRenderYoutubeEmbedPlaceholderElement,
          vimeo: defaultRenderVimeoEmbedPlaceholderElement,
        }),
        carousel.createRenderElement(),
        carousel.createRenderPlaceholderElement(),
      ]),
    [],
  );

  const renderLeaf = useMemo(
    () =>
      composeRenderLeafs([
        bold.createRenderLeaf(),
        italic.createRenderLeaf(),
      ]),
    [],
  );

  const handlers = useMemo(
    () =>
      composeHandlers([
        lineBreak.createHandlers(),
        heading.createHandlers(),
        bold.createHandlers(),
        italic.createHandlers(),
        image.createHandlers(),
        carousel.createHandlers(setNeedConfirmModal, zhTW),
      ])(editor),
    [editor],
  );

  const toolbarRenderer = useCallback(
    (expanded: boolean) => {
      if (image.isSelectionInImageCaption(editor)) return null;

      if (image.isCollapsedOnImage(editor)) {
        return <LinkToolbarIcon icon={LinkIcon} controller={link} />;
      }

      if (expanded) {
        return (
          <>
            <ToggleMarkToolbarIcon icon={BoldIcon} controller={bold} />
            <ToggleMarkToolbarIcon icon={ItalicIcon} controller={italic} />
            <LinkToolbarIcon icon={LinkIcon} controller={link} />
          </>
        );
      }

      return (
        <>
          <HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
          <HeadingToolbarIcon icon={Heading2Icon} controller={heading} level={2} />
          {TOOLBAR_DIVIDER}
          <FileUploaderToolbarIcon
            icon={ImageIcon}
            controller={fileUploader}
            options={getUploadOptions(image)}
          />
          <CarouselToolbarIcon icon={CarouselIcon} controller={carousel} />
          {TOOLBAR_DIVIDER}
          <EmbedToolbarIcon icon={YoutubeIcon} controller={embed} provider="youtube" />
          <EmbedToolbarIcon icon={VimeoIcon} controller={embed} provider="vimeo" />
        </>
      );
    },
    [editor],
  );

  const [value, setValue] = useState<Descendant[]>([
    { type: PARAGRAPH_TYPE, children: [{ text: '' }] },
  ]);

  return (
    <ConfigsProvider locale={zhTW} theme="light">
      <Quadrats
        editor={editor}
        value={value}
        onChange={setValue}
        needConfirmModal={needConfirmModal}
        setNeedConfirmModal={setNeedConfirmModal}
      >
        <Toolbar fixed>{toolbarRenderer}</Toolbar>
        <Toolbar onlyRenderExpanded>{toolbarRenderer}</Toolbar>
        <Editable
          {...handlers}
          renderElement={renderElement}
          renderLeaf={renderLeaf}
        />
      </Quadrats>
    </ConfigsProvider>
  );
}
```

---

## Programmatic Operations

### Inserting Content

```typescript
import { Transforms } from '@quadrats/core';

// Insert text
Transforms.insertText(editor, 'Hello World');

// Insert image
image.insertImage(editor, 'https://example.com/image.jpg');

// Insert link
link.insertLink(editor, 'https://example.com');

// Insert divider
divider.insertDivider(editor);

// Insert table (3 rows, 4 columns)
table.insertTable(editor, 3, 4);

// Insert embedded video
embed.insertEmbed(editor, 'youtube', 'https://youtube.com/watch?v=xxx');
```

### Toggling Formats

```typescript
// Toggle bold
bold.toggleMark(editor);

// Toggle heading
heading.toggleHeading(editor, 2);  // h2

// Toggle blockquote
blockquote.toggleBlockquote(editor);

// Toggle list
list.toggleList(editor, 'ul');

// Set alignment
align.setAlign(editor, 'center');
```

### Checking State

```typescript
// Check if bold is active
const isBold = bold.isMarkActive(editor);

// Check if inside a blockquote
const inBlockquote = blockquote.isSelectionInBlockquote(editor);

// Check if cursor is on an image
const onImage = image.isCollapsedOnImage(editor);

// Check if link is active
const hasLink = link.isLinkActive(editor);
```

---

## Data Structure Examples

### Empty Document

```json
[
  {
    "type": "paragraph",
    "children": [{ "text": "" }]
  }
]
```

### Formatted Text

```json
[
  {
    "type": "paragraph",
    "children": [
      { "text": "This is " },
      { "text": "bold", "bold": true },
      { "text": " and " },
      { "text": "italic", "italic": true },
      { "text": " text" }
    ]
  }
]
```

### Headings and Paragraphs

```json
[
  {
    "type": "heading",
    "level": 1,
    "children": [{ "text": "Heading 1" }]
  },
  {
    "type": "paragraph",
    "children": [{ "text": "Body paragraph" }]
  }
]
```

### Image

```json
[
  {
    "type": "image_figure",
    "children": [
      {
        "type": "image",
        "src": "https://example.com/image.jpg",
        "width": 100,
        "children": [{ "text": "" }]
      },
      {
        "type": "image_caption",
        "children": [{ "text": "Image caption" }]
      }
    ]
  }
]
```

### List

```json
[
  {
    "type": "ul",
    "children": [
      {
        "type": "li",
        "children": [{ "text": "Item 1" }]
      },
      {
        "type": "li",
        "children": [{ "text": "Item 2" }]
      }
    ]
  }
]
```
