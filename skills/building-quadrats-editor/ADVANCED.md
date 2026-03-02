# Quadrats Advanced Features

## React Utility Library

```typescript
import {
  readFileAsBase64,
  upload,
  mockUpload,
  composeRefs,
  usePreviousValue,
  useDocumentEvents,
  useClickAway,
  useIsomorphicLayoutEffect,
  removePreviousElement,
} from '@quadrats/react/utils';
```

### readFileAsBase64

Read a file as a Base64 DataURL:

```typescript
const base64 = await readFileAsBase64(file);
// "data:image/png;base64,iVBORw0KGgo..."
```

### upload

Upload a file (with progress callback):

```typescript
interface UploadOptions {
  file: File;
  getBody: (file: File) => any;
  getHeaders: (file: File) => Record<string, string>;
  getUrl: (file: File) => string;
  uploader?: (url: string, options: RequestInit) => Promise<Response>;
  onProgress?: (percent: number) => void;
}

const result = await upload({
  file,
  getUrl: (f) => `/api/upload/${f.name}`,
  getBody: (f) => f,
  getHeaders: (f) => ({
    'Content-Type': f.type,
    'Authorization': 'Bearer token',
  }),
  onProgress: (percent) => console.log(`${percent}%`),
});
```

### mockUpload

Simulate upload progress (for testing):

```typescript
const result = await mockUpload(base64String, (percent) => {
  console.log(`Progress: ${percent}%`);
});
```

### composeRefs

Compose multiple refs (for forwardRef components):

```typescript
const MyComponent = forwardRef((props, forwardedRef) => {
  const internalRef = useRef(null);
  const composedRef = composeRefs([forwardedRef, internalRef]);

  return <div ref={composedRef}>{props.children}</div>;
});
```

### usePreviousValue

Get the previous value:

```typescript
function MyComponent({ value }) {
  const prevValue = usePreviousValue(value);

  useEffect(() => {
    if (prevValue !== value) {
      console.log(`Changed from ${prevValue} to ${value}`);
    }
  }, [value, prevValue]);
}
```

### useDocumentEvents

Register document event listeners:

```typescript
useDocumentEvents(
  () => ({
    mousedown: (event) => console.log('Mouse down', event),
    keydown: (event) => console.log('Key down', event),
  }),
  [dependencies],
);
```

### useClickAway

Detect clicks outside an element:

```typescript
const containerRef = useRef(null);

useClickAway(
  () => ({
    handler: (event) => {
      console.log('Clicked outside');
      closeDropdown();
    },
  }),
  containerRef,
  [dependencies],
);
```

### removePreviousElement

Remove the previous element (with confirm modal support):

```typescript
removePreviousElement({
  event,
  editor,
  type: 'carousel',
  confirmModal: setNeedConfirmModal,
  doConfirm: true,
});
```

---

## Context Hooks

### useMessage

Display notification messages:

```typescript
import { useMessage } from '@quadrats/react';

function MyComponent() {
  const { message } = useMessage();

  const showNotification = () => {
    message({
      type: 'success', // 'success' | 'error' | 'warning' | 'info'
      content: 'Operation successful!',
      duration: 3000, // milliseconds, auto-closes
    });
  };

  return <button onClick={showNotification}>Show notification</button>;
}
```

### useModal

Control modal state:

```typescript
import { useModal, ConfirmModalConfig } from '@quadrats/react';

function MyComponent() {
  const {
    isModalClosed,
    setIsModalClosed,
    setEmbedModalConfig,
    setCarouselModalConfig,
    setCardModalConfig,
    setConfirmModalConfig,
  } = useModal();

  const showConfirm = () => {
    setConfirmModalConfig({
      title: 'Confirm Deletion',
      content: 'Are you sure you want to delete this item?',
      onConfirm: () => {
        // Deletion logic
      },
      onCancel: () => {
        // Cancel logic
      },
    });
  };
}
```

---

## Component-Specific Hooks

### useImageResizer

Image resize hook:

```typescript
import { useImageResizer } from '@quadrats/react/image';

function CustomImageElement({ element, resizeImage }) {
  const { imageRef, focusedAndSelected, onResizeStart } = useImageResizer(
    element,
    resizeImage,
  );

  return (
    <div className={focusedAndSelected ? 'selected' : ''}>
      <img ref={imageRef} src={element.src} />
      {focusedAndSelected && (
        <div className="resize-handle" onMouseDown={onResizeStart} />
      )}
    </div>
  );
}
```

**Return values**:
| Property             | Type                          | Description                          |
|----------------------|-------------------------------|--------------------------------------|
| `imageRef`           | `RefObject<HTMLImageElement>`  | Image ref                            |
| `focusedAndSelected` | `boolean`                     | Whether both focused and selected    |
| `onResizeStart`      | `(event) => void`             | Start resize handler                 |

### useFileUploader

File upload state management:

```typescript
import { useFileUploader } from '@quadrats/react/file-uploader';

function CustomPlaceholder({ element }) {
  const { progress, error } = useFileUploader(element);

  return (
    <div className="placeholder">
      {error ? (
        <span>Upload failed: {error}</span>
      ) : (
        <progress value={progress} max={100} />
      )}
    </div>
  );
}
```

### useInputBlock

Input block hook:

```typescript
import { useInputBlock } from '@quadrats/react/input-block';

function CustomInputBlock({ element, confirm, remove }) {
  const { ... } = useInputBlock({ confirm, element, remove });

  return (
    <div>
      <input type="text" />
      <button onClick={confirm}>Confirm</button>
      <button onClick={remove}>Cancel</button>
    </div>
  );
}
```

---

## Notifier System

```typescript
import { createNotifier } from '@quadrats/react/components';
import type { Notifier, NotifierData, NotifierConfig } from '@quadrats/react/components';

// Create notifier
const notifier = createNotifier({
  render: (data) => (
    <div className={`notification notification--${data.type}`}>
      {data.children}
    </div>
  ),
  duration: 3000, // Default display duration (ms)
  maxCount: 5, // Maximum simultaneous notifications
  setRoot: (container) => {
    document.body.appendChild(container);
  },
});

// Add notification
const key = notifier.add({
  children: 'File uploaded successfully!',
  type: 'success',
  duration: 2000,
  onClose: (key) => console.log('Notification closed', key),
});

// Remove notification
notifier.remove(key);

// Configure global settings
notifier.config({
  duration: 5000,
  maxCount: 10,
});

// Get current settings
const config = notifier.getConfig();

// Destroy notifier
notifier.destroy();
```

**Notifier interface**:
| Method           | Description                      |
|------------------|----------------------------------|
| `add(data)`      | Add notification, returns key    |
| `remove(key)`    | Remove specified notification    |
| `config(configs)`| Configure global settings        |
| `getConfig()`    | Get current settings             |
| `destroy()`      | Destroy the notifier             |

---

## Low-Level API

### createRenderElement

Create a single element renderer:

```typescript
import { createRenderElement } from '@quadrats/react';

const customRenderer = createRenderElement({
  type: 'my-custom-element',
  render: (props) => (
    <div {...props.attributes} className="custom">
      {props.children}
    </div>
  ),
});
```

### createRenderElements

Batch-create element renderers:

```typescript
import { createRenderElements } from '@quadrats/react';

const renderers = createRenderElements([
  {
    type: 'type-a',
    render: (props) => <div {...props.attributes}>{props.children}</div>,
  },
  {
    type: 'type-b',
    render: (props) => <span {...props.attributes}>{props.children}</span>,
  },
]);
```

### createRenderMark

Create a mark renderer:

```typescript
import { createRenderMark } from '@quadrats/react';

const customMarkRenderer = createRenderMark({
  type: 'custom-mark',
  render: (props) => (
    <span className="custom-mark">{props.children}</span>
  ),
});
```

---

## Hotkey Constants

### Heading Hotkeys

```typescript
import { HEADING_HOTKEY } from '@quadrats/react/heading';

// HEADING_HOTKEY maps to:
// Mod+1 → h1
// Mod+2 → h2
// Mod+3 → h3
// Mod+4 → h4
// Mod+5 → h5
// Mod+6 → h6
```

### Align Hotkeys

```typescript
import {
  ALIGN_LEFT_HOTKEY,   // 'mod+shift+l'
  ALIGN_CENTER_HOTKEY, // 'mod+shift+e'
  ALIGN_RIGHT_HOTKEY,  // 'mod+shift+r'
} from '@quadrats/react/align';
```

---

## Event Handler Types

```typescript
import type { Handler, EventHandlerName } from '@quadrats/react';

// All available event names (maps to React DOMAttributes)
type EventHandlerName = keyof DOMAttributes<HTMLElement>;
// 'onKeyDown' | 'onKeyUp' | 'onMouseDown' | 'onPaste' | 'onDrop' | ...

// Event handler signature
type Handler<H extends EventHandlerName> = (
  event: GetEventByName<H>,
  editor: Editor,
  next: VoidFunction, // Pass to next handler
) => void;

// Usage example
const customHandler: Handler<'onKeyDown'> = (event, editor, next) => {
  if (event.key === 'Tab') {
    event.preventDefault();
    // Custom handling
    return;
  }
  next(); // Pass to next handler
};
```

---

## TypeScript Types

### QuadratsReactEditor

```typescript
import type { QuadratsReactEditor } from '@quadrats/react';

// Includes all Slate ReactEditor methods
// plus all Quadrats editor methods
const editor: QuadratsReactEditor = createReactEditor();

// ReactEditor methods
editor.toDOMNode(node);
editor.findPath(node);
editor.hasTarget(event);

// Quadrats methods
editor.insertText('Hello');
editor.deleteBackward('character');
```

### WithCreateHandlers

```typescript
interface WithCreateHandlers<P extends any[] = []> {
  createHandlers: (...params: P) => Handlers;
}
```

### WithCreateRenderElement

```typescript
interface WithCreateRenderElement<P extends any[] = []> {
  createRenderElement: (...params: P) => (props: RenderElementProps) => JSX.Element | null;
}
```

### WithCreateRenderLeaf

```typescript
interface WithCreateRenderLeaf<P extends any[] = []> {
  createRenderLeaf: (...params: P) => (props: RenderLeafProps) => JSX.Element;
}
```

---

## Image Special Behaviors

### Auto URL Detection

When pasting a plain text URL, the Image component auto-detects and inserts it as an image:

```typescript
// Supported image formats
// .jpg, .jpeg, .png, .gif, .webp, .svg
```

### Image Caption Line Break Handling

When pasting text into an image caption, line breaks are automatically removed:

```typescript
// Original paste: "Line one\nLine two"
// Actual insert: "Line oneLine two"
```

### Image Keyboard Shortcuts

| Shortcut               | Context              | Behavior                     |
|------------------------|----------------------|------------------------------|
| `Backspace`            | Cursor on image      | Delete image                 |
| `Delete`               | Cursor on image      | Delete image                 |
| `Ctrl+A` / `Cmd+A`    | Inside image caption | Select caption text only     |

---

## PLACEHOLDER_KEY Constant

Used to mark placeholder on text nodes:

```typescript
import { PLACEHOLDER_KEY } from '@quadrats/react';

// For CustomTypes extension
declare module '@quadrats/core' {
  interface CustomTypes {
    Text: QuadratsText & {
      [PLACEHOLDER_KEY]?: boolean;
    };
  }
}
```

---

## DnD Support

Quadrats internally uses `react-dnd` and `react-dnd-html5-backend`:

```typescript
// Automatically configured internally, supports:
// - Drag-and-drop file upload
// - Carousel item drag-to-reorder
// - Card item drag-to-reorder
// - Image drag-and-drop insertion

// NOTE: If your app already has a DndProvider, you may need to handle conflicts
```
