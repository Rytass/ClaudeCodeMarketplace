# Upload Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Upload/Upload`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Upload) | Verified 1.10.2 (2026-11-22)

File upload component with support for multiple display modes and upload status management.

## Import

```tsx
import { Upload, Uploader, UploadItem, UploadPictureCard } from '@mezzanine-ui/react';
import type {
  UploadProps,
  UploadFile,
  UploaderProps,
  UploadItemProps,
  UploadPictureCardProps,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-upload-upload--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Upload Props

| Property             | Type                                                                             | Default  | Description                                         |
| -------------------- | -------------------------------------------------------------------------------- | -------- | --------------------------------------------------- |
| `accept`             | `string`                                                                         | -        | Accepted file types (e.g. `'image/*'`, `'.pdf'`)   |
| `ariaLabels`         | `UploadPictureCardAriaLabels`                                                    | -        | Aria labels for picture cards in `cards`/`card-wall` mode |
| `disabled`           | `boolean`                                                                        | `false`  | Whether disabled                                    |
| `dropzoneHints`      | `UploaderProps['hints']`                                                         | -        | Dropzone hint messages (visible in `list`/`card-wall` modes) |
| `errorIcon`          | `ReactNode`                                                                      | -        | Default error icon when a file's status is `'error'` and no `errorIcon` is provided on the file |
| `errorMessage`       | `string`                                                                         | -        | Default error message when a file's status is `'error'` and no `errorMessage` is provided on the file |
| `files`              | `UploadFile[]`                                                                   | -        | Controlled file list                                |
| `hints`              | `UploaderProps['hints']`                                                         | -        | Hint messages displayed outside the uploader (all modes) |
| `id`                 | `string`                                                                         | -        | Input element id                                    |
| `inputProps`         | `UploaderProps['inputProps']`                                                    | -        | Props passed directly to the input element          |
| `inputRef`           | `UploaderProps['inputRef']`                                                      | -        | Ref for the input element                           |
| `maxFiles`           | `number`                                                                         | -        | Maximum number of files allowed; excess files are ignored |
| `mode`               | `UploadMode`                                                                     | `'list'` | Display mode (see Upload Mode table below)          |
| `multiple`           | `boolean`                                                                        | `false`  | Whether multi-file selection is allowed             |
| `name`               | `string`                                                                         | -        | Name attribute of the input element                 |
| `onChange`           | `(files: UploadFile[]) => void`                                                  | -        | Fired when file list changes                        |
| `onDelete`           | `(fileId: string, file: File) => void`                                           | -        | Fired when a file is deleted                        |
| `onDownload`         | `(fileId: string, file: File) => void`                                           | -        | Fired when a file is downloaded (done state)        |
| `onMaxFilesExceeded` | `(maxFiles: number, selectedCount: number, currentCount: number) => void`        | -        | Fired when maximum number of files is exceeded      |
| `onReload`           | `(fileId: string, file: File) => void`                                           | -        | Fired when a file upload is retried (error state)   |
| `onUpload`           | `(files: File[], setProgress?) => Promise<UploadFile[]> \| UploadFile[] \| ...`  | -        | Upload callback (see onUpload Return Format section)|
| `onZoomIn`           | `(fileId: string, file: File) => void`                                           | -        | Fired when zoom in is clicked on a picture card     |
| `showFileSize`       | `boolean`                                                                        | `true`   | Whether to show file size in list mode              |
| `size`               | `UploadSize` (`'main' \| 'sub'`)                                                 | `'main'` | Size of the upload component                        |
| `uploaderIcon`       | `UploaderProps['icon']`                                                          | -        | Icon configuration for different actions and states |
| `uploaderLabel`      | `UploaderProps['label']`                                                         | -        | Label configuration for different states            |

---

## UploadFile Type

```tsx
interface UploadFile {
  id: string;                    // Unique identifier
  file?: File;                   // File object
  url?: string;                  // Uploaded file URL
  status: 'loading' | 'done' | 'error';  // Upload status (UploadItemStatus)
  progress?: number;             // Progress (0-100)
  errorMessage?: string;         // Error message
  errorIcon?: ReactNode;         // Error icon
}
```

---

## onUpload Return Format

`onUpload` supports multiple return formats:

```tsx
// 1. Complete UploadFile array (with backend ID and status)
onUpload?: (files: File[], setProgress?) => Promise<UploadFile[]> | UploadFile[];

// 2. Simple ID array (status automatically set to 'done')
onUpload?: (files: File[], setProgress?) => Promise<{ id: string }[]> | { id: string }[];

// 3. No return value (backward compatible, status automatically set to 'done')
onUpload?: (files: File[], setProgress?) => Promise<void> | void;
```

---

## Upload Mode (Display Modes)

`UploadMode = 'list' | 'basic-list' | 'button-list' | 'cards' | 'card-wall'` (exhaustive). `UploadFile.status` is `UploadItemStatus = 'done' | 'error' | 'loading'`; hint `type` is `'error' | 'info'`.

| Mode          | Description                         | Use Case                                       |
| ------------- | ------------------------------------ | ---------------------------------------------- |
| `list`        | List with dropzone                   | General file upload (default)                  |
| `basic-list`  | List without drag-and-drop           | File list display without dropzone interaction |
| `button-list` | Button trigger with list below       | Inline button upload style                     |
| `cards`       | Picture card grid                    | Image file upload and preview                  |
| `card-wall`   | Uploader at top + picture cards below| Mixed drag-and-drop with image card display    |

---

## Usage Examples

### Basic Usage

```tsx
import { Upload } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicUpload() {
  const [files, setFiles] = useState<UploadFile[]>([]);

  const handleUpload = async (uploadFiles: File[]) => {
    // Simulate upload
    return uploadFiles.map((file, index) => ({
      id: `file-${Date.now()}-${index}`,
      file,
      status: 'done' as const,
    }));
  };

  return (
    <Upload
      files={files}
      onChange={setFiles}
      onUpload={handleUpload}
    />
  );
}
```

### Multi-file Upload

```tsx
<Upload
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  multiple
  maxFiles={5}
  onMaxFilesExceeded={(max) => alert(`Maximum ${max} files allowed`)}
/>
```

### Restrict File Types

```tsx
<Upload
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  accept="image/*"
  hints={[{ label: 'Only image files supported', type: 'info' }]}
/>

<Upload
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  accept=".pdf,.doc,.docx"
  hints={[{ label: 'PDF and Word files supported', type: 'info' }]}
/>
```

### Image Card Mode

```tsx
<Upload
  mode="cards"
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  accept="image/*"
  multiple
  onZoomIn={(fileId, file) => {
    // Open image preview
  }}
/>
```

### Upload with Progress

```tsx
const handleUpload = async (
  uploadFiles: File[],
  setProgress?: (index: number, progress: number) => void
) => {
  const results: UploadFile[] = [];

  for (let i = 0; i < uploadFiles.length; i++) {
    const file = uploadFiles[i];

    // Simulate upload progress
    for (let progress = 0; progress <= 100; progress += 10) {
      await delay(100);
      setProgress?.(i, progress);
    }

    // Upload complete
    const response = await api.uploadFile(file);
    results.push({
      id: response.id,
      file,
      status: 'done',
    });
  }

  return results;
};

<Upload
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  multiple
/>
```

### Display Uploaded Files

```tsx
// Load already uploaded files from backend
const [files, setFiles] = useState<UploadFile[]>([
  { id: '1', url: '/uploads/file1.pdf', status: 'done' },
  { id: '2', url: '/uploads/image1.jpg', status: 'done' },
]);

<Upload
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  onDelete={(fileId) => {
    api.deleteFile(fileId);
  }}
  onDownload={(fileId, file) => {
    // Download file
  }}
/>
```

### Button Mode

```tsx
<Upload
  mode="button-list"
  files={files}
  onChange={setFiles}
  onUpload={handleUpload}
  uploaderLabel={{ uploadLabel: 'Select files' }}
/>
```

### Error Handling

```tsx
const handleUpload = async (uploadFiles: File[]) => {
  return uploadFiles.map((file, index) => {
    if (file.size > 10 * 1024 * 1024) {
      return {
        id: `file-${Date.now()}-${index}`,
        file,
        status: 'error' as const,
        errorMessage: 'File size exceeds 10MB',
      };
    }

    return {
      id: `file-${Date.now()}-${index}`,
      file,
      status: 'done' as const,
    };
  });
};
```

---

## Sub-components

All four are exported from `@mezzanine-ui/react`. `Upload` composes them; use the others directly only for custom layouts. Types: `UploaderMode = 'basic' | 'dropzone'`, `UploadType = 'base' | 'button'`, `UploadItemType = 'icon' | 'thumbnail'`, `UploadPictureCardImageFit = 'cover' | 'contain' | 'fill' | 'none' | 'scale-down'`.

### UploaderProps

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'label'>, 'onChange'>`; `ref` is the root `HTMLLabelElement`.

| Property        | Type                                  | Default   | Description |
| --------------- | ------------------------------------- | --------- | ----------- |
| `accept`        | `string`                              | -         | Accepted file types |
| `controllerRef` | `Ref<UploadPictureControl \| null>`   | -         | Declared in the interface but not used by the component (destructured and discarded) |
| `disabled`      | `boolean`                             | `false`   | Whether disabled |
| `externalHints` | `UploaderHint[]`                      | -         | Hints rendered outside the uploader |
| `hints`         | `UploaderHint[]` (`{ label: string; type?: 'error' \| 'info' }`) | - | Hints inside the uploader |
| `icon`          | `UploaderIcon`                        | -         | `upload?: IconDefinition`; `error` / `success` / `zoom` / `document` / `download` / `reload` / `delete?: ReactNode` |
| `id`            | `string`                              | -         | Input id |
| `inputProps`    | `UploaderInputElementProps`           | -         | Native input props |
| `inputRef`      | `Ref<HTMLInputElement>`               | -         | Input ref |
| `label`         | `UploaderLabel`                       | -         | `uploadLabel` / `uploadingLabel` / `success` / `error` / `clickToUpload` (all `string`) |
| `mode`          | `UploaderMode`                        | `'basic'` | Basic or dropzone |
| `multiple`      | `boolean`                             | `false`   | Multi-file selection |
| `name`          | `string`                              | -         | Input name |
| `onChange`      | `ChangeEventHandler<HTMLInputElement>` | -        | Native input change |
| `onUpload`      | `(files: File[]) => void`             | -         | Called with the selected files |
| `type`          | `UploadType`                          | -         | `'base'` or `'button'` |

### UploadItemProps

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`; `ref` is the root `HTMLDivElement`.

| Property       | Type                | Default    | Description |
| -------------- | ------------------- | ---------- | ----------- |
| `disabled`     | `boolean`           | `false`    | Whether disabled |
| `errorIcon`    | `IconDefinition`    | -          | Error icon |
| `errorMessage` | `string`            | -          | Error message |
| `file`         | `File`              | -          | File object |
| `fileSize`     | `number`            | -          | File size in bytes |
| `icon`         | `IconDefinition`    | -          | Custom icon |
| `id`           | `string`            | -          | Item id |
| `onCancel` / `onDelete` / `onDownload` / `onReload` | `MouseEventHandler` | - | Action callbacks |
| `showFileSize` | `boolean`           | `true`     | Show file size |
| `size`         | `UploadItemSize` (`'main' \| 'sub'`) | `'main'` | Size |
| `status`       | `UploadItemStatus`  | `'loading'` (required in type) | `'done' \| 'error' \| 'loading'` |
| `type`         | `UploadItemType`    | `'icon'`   | Icon or thumbnail |
| `url`          | `string`            | -          | File URL |

### UploadPictureCardProps

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`; `ref` is the root `HTMLDivElement`.

| Property       | Type                                | Default     | Description |
| -------------- | ----------------------------------- | ----------- | ----------- |
| `ariaLabels`   | `UploadPictureCardAriaLabels`       | -           | `cancelUpload` / `clickToReplace` / `delete` / `download` / `reload` / `uploading` / `zoomIn` (all `string`) |
| `disabled`     | `boolean`           | `false`     | Whether disabled |
| `errorIcon`    | `IconDefinition`    | -           | Error icon |
| `errorMessage` | `string`            | -           | Error message |
| `file`         | `File`              | -           | File object |
| `id`           | `string`            | -           | Card id |
| `imageFit`     | `UploadPictureCardImageFit` | `'cover'` | Image fit |
| `onDelete` / `onDownload` / `onReload` / `onReplace` / `onZoomIn` | `MouseEventHandler` | - | Action callbacks |
| `readable`     | `boolean`           | `false`     | Read-only display |
| `size`         | `UploadPictureCardSize` (`'main' \| 'sub' \| 'minor'`) | `'main'` | Size |
| `status`       | `UploadItemStatus`  | `'loading'` | Upload status |
| `url`          | `string`            | -           | Image URL |

Behavior: in single-file mode, hovering the uploaded image shows a "Replace" overlay; zoom and download buttons render only when the corresponding callbacks (`onZoomIn`, `onDownload`) are provided; the card supports keyboard interaction.

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `Upload / List`              | `mode="list"`                            |
| `Upload / Basic List`        | `mode="basic-list"`                      |
| `Upload / Button List`       | `mode="button-list"`                     |
| `Upload / Cards`             | `mode="cards"`                           |
| `Upload / Card Wall`         | `mode="card-wall"`                       |
| `Upload / Loading`           | `files=[{ status: 'loading' }]`          |
| `Upload / Error`             | `files=[{ status: 'error' }]`            |

---

## Best Practices

1. **Controlled mode**: Use `files` and `onChange` to manage state
2. **Restrict files**: Set `accept` and `maxFiles` to limit uploads
3. **Progress reporting**: Use `setProgress` for long uploads to report progress
4. **Error handling**: Provide clear `errorMessage`
5. **Appropriate mode**: Use `cards` for images, `list` for documents
