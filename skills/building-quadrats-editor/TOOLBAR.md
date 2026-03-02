# Quadrats Toolbar Configuration Guide

## Core Toolbar Components

```typescript
import { Toolbar, ToolbarGroupIcon, TOOLBAR_DIVIDER } from '@quadrats/react/toolbar';
```

## Basic Usage

```typescript
<Quadrats editor={editor} value={value} onChange={setValue}>
  {/* Fixed toolbar */}
  <Toolbar fixed>{toolbarRenderer}</Toolbar>

  {/* Toolbar shown only when text is selected */}
  <Toolbar onlyRenderExpanded>{toolbarRenderer}</Toolbar>

  <Editable {...handlers} renderElement={renderElement} renderLeaf={renderLeaf} />
</Quadrats>
```

## Toolbar Props

| Prop                 | Type        | Description                              |
|----------------------|-------------|------------------------------------------|
| `fixed`              | `boolean`   | Always display the toolbar               |
| `onlyRenderExpanded` | `boolean`   | Display only when text is selected       |
| `children`           | `(expanded: boolean) => ReactNode` | Render function |

---

## Toolbar Render Function

```typescript
const toolbarRenderer = useCallback((expanded: boolean) => {
  // expanded: true means text is selected

  if (expanded) {
    // Tools shown when text is selected (typically text formatting)
    return (
      <>
        <ToggleMarkToolbarIcon icon={BoldIcon} controller={bold} />
        <ToggleMarkToolbarIcon icon={ItalicIcon} controller={italic} />
        <LinkToolbarIcon icon={LinkIcon} controller={link} />
      </>
    );
  }

  // Tools shown when no text is selected (typically block operations)
  return (
    <>
      <ParagraphToolbarIcon icon={ParagraphIcon} controller={paragraph} />
      <HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
      <HeadingToolbarIcon icon={Heading2Icon} controller={heading} level={2} />
      {TOOLBAR_DIVIDER}
      <FileUploaderToolbarIcon icon={ImageIcon} controller={fileUploader} options={uploadOptions} />
    </>
  );
}, [dependencies]);
```

---

## Available Toolbar Icon Components

### Mark Component Tools

```typescript
import { ToggleMarkToolbarIcon } from '@quadrats/react/toggle-mark/toolbar';

// Bold, Italic, Underline, Strikethrough, Highlight all use this
<ToggleMarkToolbarIcon icon={BoldIcon} controller={bold} />
<ToggleMarkToolbarIcon icon={ItalicIcon} controller={italic} />
<ToggleMarkToolbarIcon icon={UnderlineIcon} controller={underline} />
<ToggleMarkToolbarIcon icon={StrikethroughIcon} controller={strikethrough} />
<ToggleMarkToolbarIcon icon={HighlightIcon} controller={highlight} />
```

---

### Block Component Tools

```typescript
// Paragraph
import { ParagraphToolbarIcon } from '@quadrats/react/paragraph/toolbar';
<ParagraphToolbarIcon icon={ParagraphIcon} controller={paragraph} />

// Heading
import { HeadingToolbarIcon } from '@quadrats/react/heading/toolbar';
<HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
<HeadingToolbarIcon icon={Heading2Icon} controller={heading} level={2} />
<HeadingToolbarIcon icon={Heading3Icon} controller={heading} level={3} />

// Blockquote
import { BlockquoteToolbarIcon } from '@quadrats/react/blockquote/toolbar';
<BlockquoteToolbarIcon icon={BlockquoteIcon} controller={blockquote} />

// Divider
import { DividerToolbarIcon } from '@quadrats/react/divider/toolbar';
<DividerToolbarIcon icon={DividerIcon} controller={divider} />

// List
import { ListToolbarIcon } from '@quadrats/react/list/toolbar';
<ListToolbarIcon icon={UnorderedListIcon} controller={list} listTypeKey="ul" />
<ListToolbarIcon icon={OrderedListIcon} controller={list} listTypeKey="ol" />

// Table
import { TableToolbarIcon } from '@quadrats/react/table/toolbar';
<TableToolbarIcon icon={TableIcon} controller={table} />

// Accordion
import { AccordionToolbarIcon } from '@quadrats/react/accordion/toolbar';
<AccordionToolbarIcon icon={AccordionIcon} controller={accordion} />
```

---

### Media Component Tools

```typescript
// Image (via FileUploader)
import { FileUploaderToolbarIcon } from '@quadrats/react/file-uploader/toolbar';
<FileUploaderToolbarIcon
  icon={ImageIcon}
  controller={fileUploader}
  options={uploadOptions}
/>

// Carousel
import { CarouselToolbarIcon } from '@quadrats/react/carousel/toolbar';
<CarouselToolbarIcon icon={CarouselIcon} controller={carousel} />

// Card
import { CardToolbarIcon } from '@quadrats/react/card/toolbar';
<CardToolbarIcon icon={CardIcon} controller={card} />

// Embed (provider MUST be specified)
import { EmbedToolbarIcon } from '@quadrats/react/embed/toolbar';
<EmbedToolbarIcon icon={YoutubeIcon} controller={embed} provider="youtube" />
<EmbedToolbarIcon icon={VimeoIcon} controller={embed} provider="vimeo" />
<EmbedToolbarIcon icon={InstagramIcon} controller={embed} provider="instagram" />
<EmbedToolbarIcon icon={FacebookIcon} controller={embed} provider="facebook" />
<EmbedToolbarIcon icon={TwitterIcon} controller={embed} provider="twitter" />
<EmbedToolbarIcon icon={SpotifyIcon} controller={embed} provider="spotify" />
<EmbedToolbarIcon icon={PodcastAppleIcon} controller={embed} provider="podcastApple" />
```

---

### Special Component Tools

```typescript
// Link
import { LinkToolbarIcon, UnlinkToolbarIcon } from '@quadrats/react/link/toolbar';
<LinkToolbarIcon icon={LinkIcon} controller={link} />
<UnlinkToolbarIcon icon={UnlinkIcon} controller={link} />

// Footnote
import { FootnoteToolbarIcon } from '@quadrats/react/footnote/toolbar';
<FootnoteToolbarIcon icon={FnIcon} controller={footnote} />

// ReadMore
import { ReadMoreToolbarIcon } from '@quadrats/react/read-more/toolbar';
<ReadMoreToolbarIcon icon={ReadMoreIcon} controller={readMore} />

// Align
import { AlignToolbarIcon } from '@quadrats/react/align/toolbar';
<AlignToolbarIcon icon={AlignLeftIcon} controller={align} value="left" />
<AlignToolbarIcon icon={AlignCenterIcon} controller={align} value="center" />
<AlignToolbarIcon icon={AlignRightIcon} controller={align} value="right" />
```

---

## Icon Package

All icons are from `@quadrats/icons`:

```typescript
import {
  // Text formatting
  Bold as BoldIcon,
  Italic as ItalicIcon,
  Underline as UnderlineIcon,
  Strikethrough as StrikethroughIcon,
  Highlight as HighlightIcon,

  // Blocks
  Paragraph as ParagraphIcon,
  Heading1 as Heading1Icon,
  Heading2 as Heading2Icon,
  Heading3 as Heading3Icon,
  Heading4 as Heading4Icon,
  Heading5 as Heading5Icon,
  Heading6 as Heading6Icon,
  Blockquote as BlockquoteIcon,
  Divider as DividerIcon,
  UnorderedList as UnorderedListIcon,
  OrderedList as OrderedListIcon,
  Table as TableIcon,
  Accordion as AccordionIcon,

  // Media
  Image as ImageIcon,
  Youtube as YoutubeIcon,
  Vimeo as VimeoIcon,
  Instagram as InstagramIcon,
  Facebook as FacebookIcon,
  Twitter as TwitterIcon,
  Spotify as SpotifyIcon,
  PodcastApple as PodcastAppleIcon,
  Carousel as CarouselIcon,
  Card as CardIcon,

  // Special
  Link as LinkIcon,
  Unlink as UnlinkIcon,
  Fn as FnIcon,
  ReadMore as ReadMoreIcon,
  AlignLeft as AlignLeftIcon,
  AlignCenter as AlignCenterIcon,
  AlignRight as AlignRightIcon,
} from '@quadrats/icons';
```

---

## Toolbar Grouping

Use `ToolbarGroupIcon` to create dropdown menus:

```typescript
<ToolbarGroupIcon icon={ParagraphIcon}>
  <ParagraphToolbarIcon icon={ParagraphIcon} controller={paragraph} />
  <HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
  <HeadingToolbarIcon icon={Heading2Icon} controller={heading} level={2} />
  <HeadingToolbarIcon icon={Heading3Icon} controller={heading} level={3} />
</ToolbarGroupIcon>

<ToolbarGroupIcon icon={AlignLeftIcon}>
  <AlignToolbarIcon icon={AlignLeftIcon} controller={align} value="left" />
  <AlignToolbarIcon icon={AlignCenterIcon} controller={align} value="center" />
  <AlignToolbarIcon icon={AlignRightIcon} controller={align} value="right" />
</ToolbarGroupIcon>
```

---

## Toolbar Divider

```typescript
import { TOOLBAR_DIVIDER } from '@quadrats/react/toolbar';

// Insert divider between tools
<>
  <ParagraphToolbarIcon icon={ParagraphIcon} controller={paragraph} />
  <HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
  {TOOLBAR_DIVIDER}
  <FileUploaderToolbarIcon icon={ImageIcon} controller={fileUploader} options={uploadOptions} />
</>
```

---

## Contextual Rendering

Display different tools based on cursor position:

```typescript
const toolbarRenderer = useCallback((expanded: boolean) => {
  // Hide toolbar when inside image caption
  if (image.isSelectionInImageCaption(editor)) {
    return null;
  }

  // Show only link tool when cursor is on an image
  if (image.isCollapsedOnImage(editor)) {
    return (
      <>
        <LinkToolbarIcon icon={LinkIcon} controller={link} />
        <UnlinkToolbarIcon icon={UnlinkIcon} controller={link} />
      </>
    );
  }

  // Show only blockquote tool when inside a blockquote
  if (blockquote.isSelectionInBlockquote(editor)) {
    return <BlockquoteToolbarIcon icon={BlockquoteIcon} controller={blockquote} />;
  }

  // Show text formatting tools when text is selected
  if (expanded) {
    return (
      <>
        <ToggleMarkToolbarIcon icon={BoldIcon} controller={bold} />
        <ToggleMarkToolbarIcon icon={ItalicIcon} controller={italic} />
        <LinkToolbarIcon icon={LinkIcon} controller={link} />
      </>
    );
  }

  // Default: show block tools
  return (
    <>
      <ParagraphToolbarIcon icon={ParagraphIcon} controller={paragraph} />
      <HeadingToolbarIcon icon={Heading1Icon} controller={heading} level={1} />
      {TOOLBAR_DIVIDER}
      <FileUploaderToolbarIcon icon={ImageIcon} controller={fileUploader} options={uploadOptions} />
    </>
  );
}, [editor, image, blockquote, bold, italic, link, heading, paragraph, fileUploader, uploadOptions]);
```

---

## Confirm Modal (Carousel / Card Deletion)

Carousel and Card require a confirmation modal when deleting:

```typescript
import { ConfirmModalConfig } from '@quadrats/react';

function MyEditor() {
  const [needConfirmModal, setNeedConfirmModal] = useState<ConfirmModalConfig | null>(null);

  // Pass setNeedConfirmModal to handlers
  const handlers = useMemo(() => {
    const h = [
      carousel.createHandlers(setNeedConfirmModal, locale),
      card.createHandlers(setNeedConfirmModal, locale),
    ];
    return composeHandlers(h)(editor);
  }, [editor, locale]);

  return (
    <Quadrats
      editor={editor}
      value={value}
      onChange={setValue}
      needConfirmModal={needConfirmModal}
      setNeedConfirmModal={setNeedConfirmModal}
    >
      <Editable {...handlers} />
    </Quadrats>
  );
}
```
