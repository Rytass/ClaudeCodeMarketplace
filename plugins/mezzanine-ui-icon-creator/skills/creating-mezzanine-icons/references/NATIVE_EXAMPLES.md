# Native Icon Inventory & Canonical Sources

`@mezzanine-ui/icons` 1.0.2 — 130 icons. **Always check this inventory before creating a
custom icon**; if a native icon covers the semantic, use it instead.

## Full inventory by category

**alert/** (12 — status, filled/outline pairs):
CheckedFilled, CheckedOutline, ErrorFilled, ErrorOutline, WarningFilled, WarningOutline,
InfoFilled, InfoOutline, DangerousFilled, DangerousOutline, QuestionFilled, QuestionOutline

**arrow/** (26 — direction):
LongTailArrowRight, LongTailArrowLeft, LongTailArrowUp, LongTailArrowDown,
ShortTailArrowRight, ShortTailArrowLeft, ShortTailArrowUp, ShortTailArrowDown,
CaretRight, CaretLeft, CaretUp, CaretDown, CaretUpFlat, CaretDownFlat, CaretVertical,
ChevronRight, ChevronLeft, ChevronUp, ChevronDown, ChevronVertical,
DoubleChevronRight, DoubleChevronLeft, SwitchVertical, ReverseLeft, ReverseRight

**content/** (29 — files, media, actions):
Download, Upload, File, FileSearch, FileAttachment, Edit, Copy, Link, Share, LinkExternal,
Gallery, List, AlignLeft, AlignRight, StarOutline, StarFilled, BookmarkOutline,
BookmarkFilled, BookmarkAdd, BookmarkRemove, BookmarkAdded, Image, Box, Code, Camera,
CameraAdd, Mail, MailUnread, Nfc

**controls/** (26 — UI operations):
Close, Trash, Setting, Filter, Reset, RefreshCcw, RefreshCw, Eye, EyeInvisible, Plus,
Minus, Checked, DotVertical, DotHorizontal, DotGrid, DotDragVertical, DotDragHorizontal,
ZoomIn, ZoomOut, Pin, PinFilled, Maximize, Minimize, ResizeHandle, Lock, Unlock

**stepper/** (10): Item0 … Item9

**system/** (27 — app chrome):
Menu, MenuOpen, MenuClose, Search, SearchHistory, User, Slash, Folder, FolderOpen,
FolderMove, FolderAdd, Calendar, CalendarTime, Clock, CurrencyDollar, Percent, Light,
Dark, Notification, NotificationUnread, Sider, Home, Spinner, Login, Logout, Save, System

All exported as `XxxIcon` from `@mezzanine-ui/icons` (e.g. `import { SearchIcon } from '@mezzanine-ui/icons'`).

## Canonical annotated sources

Use these as style anchors — the archetype each one canonizes is noted.

### Line-work glyph — `ChevronDownIcon`

45° V-stroke, width 1u, square caps. Centerline `(3.5,6)→(8,10.5)→(12.5,6)`.

```ts
export const ChevronDownIcon: IconDefinition = {
  name: 'chevron-down',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M12.1465 5.64648L8 9.79297L3.85352 5.64648L3.14648 6.35352L8 11.207L12.8535 6.35352L12.1465 5.64648Z',
    },
  },
};
```

### Axis-aligned line work — `PlusIcon`

Two 1u bars (centerlines x=8, y=8), extent 3..13. All coords integers/halves.

```ts
export const PlusIcon: IconDefinition = {
  name: 'plus',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M8.5 7.5H13V8.5H8.5V13H7.5V8.5H3V7.5H7.5V3H8.5V7.5Z',
    },
  },
};
```

### 45° cross — `CloseIcon`

Two 45° strokes, width 1u; note the `0.35352` / `0.70703`-derived coordinates.

```ts
export const CloseIcon: IconDefinition = {
  name: 'close',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M12.7539 4.35352L8.90723 8.19922L12.7539 12.0459L12.0469 12.7529L8.2002 8.90625L4.35352 12.7529L3.64648 12.0459L7.49219 8.19922L3.64648 4.35352L4.35352 3.64648L8.2002 7.49219L12.0469 3.64648L12.7539 4.35352Z',
    },
  },
};
```

### Filled badge + knockout — `CheckedFilledIcon`

Ø12 kappa circle (CW) + check mark wound CCW (nonzero knockout).

```ts
export const CheckedFilledIcon: IconDefinition = {
  name: 'checked-filled',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M8 2C11.3137 2 14 4.68629 14 8C14 11.3137 11.3137 14 8 14C4.68629 14 2 11.3137 2 8C2 4.68629 4.68629 2 8 2ZM7.10938 8.99023L5.65918 7.54004L4.95215 8.24707L7.10938 10.4043L11.0596 6.4541L10.3525 5.74707L7.10938 8.99023Z',
    },
  },
};
```

### Ring badge — `CheckedOutlineIcon`

Ø12 CW + Ø10 CCW = 1u ring; symbol painted back inside as a third subpath.

```ts
export const CheckedOutlineIcon: IconDefinition = {
  name: 'checked-outline',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M8 2C11.3137 2 14 4.68629 14 8C14 11.3137 11.3137 14 8 14C4.68629 14 2 11.3137 2 8C2 4.68629 4.68629 2 8 2ZM8 3C5.23858 3 3 5.23858 3 8C3 10.7614 5.23858 13 8 13C10.7614 13 13 10.7614 13 8C13 5.23858 10.7614 3 8 3ZM11.0596 6.4541L7.10938 10.4043L4.95215 8.24707L5.65918 7.54004L7.10938 8.99023L10.3525 5.74707L11.0596 6.4541Z',
    },
  },
};
```

### Container + content — `FileIcon`

Rounded outer shell (radius 1.5, kappa corners), square inner knockout via opposite
winding, 1u wall, 1u inner text lines with 1u+ clearance.

```ts
export const FileIcon: IconDefinition = {
  name: 'file',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M11.5 2C12.3284 2 13 2.67157 13 3.5V12.5C13 13.3284 12.3284 14 11.5 14H4.5C3.67157 14 3 13.3284 3 12.5V3.5C3 2.67157 3.67157 2 4.5 2H11.5ZM4 13H12V3H4V13ZM9 6.5V7.5H5.40039V6.5H9ZM10.6006 4.2998V5.2998H5.40039V4.2998H10.6006Z',
    },
  },
};
```

### Container variant — `TrashIcon`

Rounded only where the metaphor rounds (bin bottom); lid/rim as 1u bars; 1u inner ticks.

```ts
export const TrashIcon: IconDefinition = {
  name: 'trash',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M13.5 3.5V4.5H12.7861V13C12.7861 13.8284 12.1146 14.5 11.2861 14.5H4.71484C3.88642 14.5 3.21484 13.8284 3.21484 13V4.5H2.5V3.5H13.5ZM4.21484 13.5H11.7861V4.5H4.21484V13.5ZM7.10059 6.8V11.2H6.10059V6.8H7.10059ZM9.90039 6.8V11.2H8.90039V6.8H9.90039ZM10 1.5V2.5H6V1.5H10Z',
    },
  },
};
```

### Long-tail arrow — `LongTailArrowRightIcon`

1u shaft + 45° V head, tip at `(14.207, 8)`.

```ts
export const LongTailArrowRightIcon: IconDefinition = {
  name: 'long-tail-arrow-right',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M14.207 8L9.85352 12.3535L9.14648 11.6465L12.293 8.5H2V7.5H12.293L9.14648 4.35352L9.85352 3.64648L14.207 8Z',
    },
  },
};
```

### Solid caret — `CaretDownIcon`

Solid triangle: base 9u at y=4.5, apex `(8,11.5)`. (Native carries a redundant
`fillRule/clipRule: 'evenodd'` — omit it for new solid shapes.)

```ts
export const CaretDownIcon: IconDefinition = {
  name: 'caret-down',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      fillRule: 'evenodd',
      clipRule: 'evenodd',
      d: 'M3.5 4.5L8 11.5L12.5 4.5L3.5 4.5Z',
    },
  },
};
```

### Concave outline — `StarOutlineIcon`

Outline of a non-convex shape: outer star + inner star offset ~1u perpendicular to each
edge. Use as the anchor when outlining organic/pointed shapes.

```ts
export const StarOutlineIcon: IconDefinition = {
  name: 'star-outline',
  definition: {
    svg: { viewBox: '0 0 16 16', fill: 'none' },
    path: {
      fill: 'currentColor',
      d: 'M10.0693 5.47095L14.1992 6.30396L13.5996 6.95728L11.3467 9.40649L11.832 13.592L8 11.8381L4.16895 13.592L4.65234 9.40552L1.80078 6.30396L5.93066 5.47095L8 1.80005L10.0693 5.47095ZM6.57812 6.3606L6.35352 6.40552L3.73828 6.93286L5.54395 8.89771L5.69824 9.06665L5.67285 9.29419L5.36621 11.9436L7.79199 10.8342L8 10.7385L8.20801 10.8342L10.6338 11.9436L10.3018 9.06665L12.2617 6.93384L9.64746 6.40552L9.42285 6.3606L8 3.83618L6.57812 6.3606Z',
    },
  },
};
```

## Reading more native sources

When a custom icon resembles a specific native one, read its actual source before
constructing — sources live at `packages/icons/src/<category>/<kebab-name>.ts` in the
[Mezzanine-UI monorepo](https://github.com/Mezzanine-UI/mezzanine). If the monorepo is
checked out locally (commonly as a sibling `mezzanine/` directory), read it from disk;
otherwise fetch from GitHub raw. Copying geometry from the closest native neighbor always
beats inventing new geometry.
