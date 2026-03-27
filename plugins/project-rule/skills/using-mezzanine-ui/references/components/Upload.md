# Upload Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Upload`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/react/src/Upload) | Verified rc.8 (2026-03-27)

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

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/?path=/docs/data-entry-upload--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Upload Props

| Property            | Type                                                | Default    | Description              |
| ------------------- | --------------------------------------------------- | ---------- | ------------------------ |
| `accept`            | `string`                                            | -          | Accepted file types      |
| `disabled`          | `boolean`                                           | `false`    | Whether disabled         |
| `dropzoneHints`     | `string[]`                                          | -          | **NEW in rc.8** — Dropzone hint messages |
| `files`             | `UploadFile[]`                                      | `[]`       | File list (controlled)   |
| `hints`             | `UploaderHint[]`                                    | -          | Hint messages            |
| `id`                | `string`                                            | -          | Input element id         |
| `inputProps`        | `UploaderInputElementProps`                         | -          | Props passed to input element |
| `inputRef`          | `Ref<HTMLInputElement>`                             | -          | Input element ref        |
| `isFillWidth`       | `boolean`                                           | `false`    | Whether to fill container width |
| `maxFiles`          | `number`                                            | -          | Maximum number of files  |
| `mode`              | `'list' \| 'button-list' \| 'cards' \| 'card-wall'` | `'list'`   | Display mode             |
| `multiple`          | `boolean`                                           | `false`    | Whether multi-select     |
| `name`              | `string`                                            | -          | Input element name attribute |
| `onChange`          | `(files: UploadFile[]) => void`                     | -          | File change callback     |
| `onDelete`          | `(fileId, file) => void`                            | -          | Delete callback          |
| `onDownload`        | `(fileId, file) => void`                            | -          | Download callback        |
| `onMaxFilesExceeded`| `(max, selected, current) => void`                  | -          | Max files exceeded callback |
| `onReload`          | `(fileId, file) => void`                            | -          | Retry callback           |
| `onUpload`          | `(files, setProgress) => Promise<UploadFile[]> \| ...` | -       | Upload callback (see below) |
| `onZoomIn`          | `(fileId, file) => void`                            | -          | Zoom preview callback    |
| `showFileSize`      | `boolean`                                           | `true`     | Show file size           |
| `size`              | `UploadSize`                                        | `'main'`   | Size                     |
| `uploaderIcon`      | `UploaderProps['icon']`                             | -          | Upload area icon         |
| `uploaderLabel`     | `UploaderProps['label']`                            | -          | Upload area text         |

**Removed in rc.8**: `errorIcon`, `errorMessage`, `isFillWidth`, `multiple`, `name`, `onChange`, `onDelete`, `onDownload`, `onMaxFilesExceeded`, `onReload`, `onZoomIn`, `showFileSize`, `size`, `uploaderLabel` — Refer to Storybook for updated API patterns.

---

## UploadFile Type

```tsx
interface UploadFile {
  id: string;                    // Unique identifier
  file?: File;                   // File object
  url?: string;                  // Uploaded file URL
  status: 'loading' | 'done' | 'error';  // Upload status
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

| Mode          | Description    | Use Case              |
| ------------- | -------------- | --------------------- |
| `list`        | List mode      | General file upload   |
| `button-list` | Button + list  | Inline button upload  |
| `cards`       | Card mode      | Image upload          |
| `card-wall`   | Card wall      | Top drag + image cards |

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

## UploadPictureCard Enhancements

- **Single-file hover replace mode**: In single-file mode, hovering over the uploaded image shows a "Replace" overlay, allowing the user to replace the file directly
- **Conditional zoom/download buttons**: Zoom and download action buttons are now conditionally rendered based on whether the corresponding callbacks (`onZoomIn`, `onDownload`) are provided
- **Keyboard interaction support (a11y)**: UploadPictureCard now supports keyboard navigation and interaction for improved accessibility

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `Upload / List`              | `mode="list"`                            |
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
