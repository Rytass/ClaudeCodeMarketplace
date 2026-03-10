# gws Drive Operations

Complete reference for Google Drive operations via the `gws` CLI.

## Prerequisites

```bash
gws auth login --scopes drive
```

## List Files

```bash
# List recent files
gws drive files list --params '{"pageSize":10}'

# List with specific fields
gws drive files list --params '{"pageSize":10,"fields":"files(id,name,mimeType,modifiedTime,size)"}'

# List all files (paginated)
gws drive files list --params '{"pageSize":100}' --page-all

# List files in a specific folder
gws drive files list --params '{"q":"\"FOLDER_ID\" in parents","pageSize":20}'

# List only folders
gws drive files list --params '{"q":"mimeType=\"application/vnd.google-apps.folder\"","pageSize":20}'
```

## Search Files

```bash
# Search by name
gws drive files list --params '{"q":"name contains \"report\"","pageSize":10}'

# Search by exact name
gws drive files list --params '{"q":"name = \"Q4 Report.pdf\"","pageSize":10}'

# Search by MIME type
gws drive files list --params '{"q":"mimeType=\"application/pdf\"","pageSize":10}'

# Search Google Docs only
gws drive files list --params '{"q":"mimeType=\"application/vnd.google-apps.document\"","pageSize":10}'

# Search Google Sheets only
gws drive files list --params '{"q":"mimeType=\"application/vnd.google-apps.spreadsheet\"","pageSize":10}'

# Search by owner
gws drive files list --params '{"q":"\"user@example.com\" in owners","pageSize":10}'

# Search shared with me
gws drive files list --params '{"q":"sharedWithMe=true","pageSize":10}'

# Search starred files
gws drive files list --params '{"q":"starred=true","pageSize":10}'

# Search in trash
gws drive files list --params '{"q":"trashed=true","pageSize":10}'

# Full-text search (file content)
gws drive files list --params '{"q":"fullText contains \"quarterly revenue\"","pageSize":10}'

# Combine search criteria
gws drive files list --params '{"q":"mimeType=\"application/pdf\" and name contains \"invoice\" and modifiedTime > \"2025-01-01T00:00:00\"","pageSize":10}'
```

### Drive Search Operators

| Operator                | Example                                         | Description              |
| ----------------------- | ----------------------------------------------- | ------------------------ |
| `name contains`         | `name contains "report"`                        | Name substring match     |
| `name =`                | `name = "exact.pdf"`                            | Exact name match         |
| `mimeType =`            | `mimeType = "application/pdf"`                  | File type                |
| `fullText contains`     | `fullText contains "keyword"`                   | Content search           |
| `in parents`            | `"FOLDER_ID" in parents`                        | Files in folder          |
| `in owners`             | `"user@example.com" in owners`                  | Files by owner           |
| `sharedWithMe`          | `sharedWithMe = true`                           | Shared files             |
| `starred`               | `starred = true`                                | Starred files            |
| `trashed`               | `trashed = true`                                | Trashed files            |
| `modifiedTime >`        | `modifiedTime > "2025-01-01T00:00:00"`          | Modified after date      |
| `createdTime >`         | `createdTime > "2025-01-01T00:00:00"`           | Created after date       |

## Get File Metadata

```bash
# Get file details
gws drive files get --params '{"fileId":"FILE_ID"}'

# Get specific fields
gws drive files get --params '{"fileId":"FILE_ID","fields":"id,name,mimeType,size,modifiedTime,webViewLink,parents"}'
```

## Upload Files

```bash
# Simple upload
gws drive files create --json '{"name":"report.pdf"}' --upload ./report.pdf

# Upload with MIME type
gws drive files create --json '{"name":"data.csv","mimeType":"text/csv"}' --upload ./data.csv

# Upload to a specific folder
gws drive files create --json '{"name":"photo.jpg","parents":["FOLDER_ID"]}' --upload ./photo.jpg

# Upload and convert to Google Docs format
gws drive files create --json '{"name":"document","mimeType":"application/vnd.google-apps.document"}' --upload ./document.docx

# Upload and convert to Google Sheets
gws drive files create --json '{"name":"spreadsheet","mimeType":"application/vnd.google-apps.spreadsheet"}' --upload ./data.xlsx
```

## Download Files

```bash
# Download a file (binary content)
gws drive files get --params '{"fileId":"FILE_ID","alt":"media"}' > downloaded_file.pdf

# Export Google Docs as PDF
gws drive files export --params '{"fileId":"DOC_ID","mimeType":"application/pdf"}' > document.pdf

# Export Google Sheets as CSV
gws drive files export --params '{"fileId":"SHEET_ID","mimeType":"text/csv"}' > spreadsheet.csv

# Export Google Slides as PDF
gws drive files export --params '{"fileId":"SLIDES_ID","mimeType":"application/pdf"}' > presentation.pdf

# Export Google Docs as plain text
gws drive files export --params '{"fileId":"DOC_ID","mimeType":"text/plain"}' > document.txt
```

### Export MIME Types

| Google Format      | Export As              | MIME Type                                                           |
| ------------------ | ---------------------- | ------------------------------------------------------------------- |
| Google Docs        | PDF                    | `application/pdf`                                                   |
| Google Docs        | Word                   | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` |
| Google Docs        | Plain text             | `text/plain`                                                        |
| Google Docs        | HTML                   | `text/html`                                                         |
| Google Sheets      | PDF                    | `application/pdf`                                                   |
| Google Sheets      | Excel                  | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` |
| Google Sheets      | CSV                    | `text/csv`                                                          |
| Google Slides      | PDF                    | `application/pdf`                                                   |
| Google Slides      | PowerPoint             | `application/vnd.openxmlformats-officedocument.presentationml.presentation` |

## Create Folders

```bash
# Create a folder
gws drive files create --json '{"name":"New Folder","mimeType":"application/vnd.google-apps.folder"}'

# Create a subfolder
gws drive files create --json '{"name":"Subfolder","mimeType":"application/vnd.google-apps.folder","parents":["PARENT_FOLDER_ID"]}'
```

## Move & Copy Files

```bash
# Move file to a different folder
gws drive files update --params '{"fileId":"FILE_ID","addParents":"NEW_FOLDER_ID","removeParents":"OLD_FOLDER_ID"}'

# Copy a file
gws drive files copy --params '{"fileId":"FILE_ID"}' --json '{"name":"Copy of File"}'

# Copy to a specific folder
gws drive files copy --params '{"fileId":"FILE_ID"}' --json '{"name":"Copy of File","parents":["FOLDER_ID"]}'
```

## Rename & Update

```bash
# Rename a file
gws drive files update --params '{"fileId":"FILE_ID"}' --json '{"name":"New Name.pdf"}'

# Update file content (replace)
gws drive files update --params '{"fileId":"FILE_ID"}' --upload ./updated_file.pdf

# Star a file
gws drive files update --params '{"fileId":"FILE_ID"}' --json '{"starred":true}'

# Add description
gws drive files update --params '{"fileId":"FILE_ID"}' --json '{"description":"Q4 financial report for 2025"}'
```

## Delete & Trash

```bash
# Move to trash
gws drive files update --params '{"fileId":"FILE_ID"}' --json '{"trashed":true}'

# Restore from trash
gws drive files update --params '{"fileId":"FILE_ID"}' --json '{"trashed":false}'

# Permanently delete (irreversible!)
gws drive files delete --params '{"fileId":"FILE_ID"}'

# Empty trash
gws drive files emptyTrash
```

## Permissions (Sharing)

```bash
# List permissions
gws drive permissions list --params '{"fileId":"FILE_ID"}'

# Share with a user (editor)
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"type":"user","role":"writer","emailAddress":"user@example.com"}'

# Share with a user (viewer)
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"type":"user","role":"reader","emailAddress":"user@example.com"}'

# Share with a user (commenter)
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"type":"user","role":"commenter","emailAddress":"user@example.com"}'

# Share with a Google Group
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"type":"group","role":"writer","emailAddress":"team@example.com"}'

# Share with anyone (link sharing)
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"type":"anyone","role":"reader"}'

# Share with domain
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"type":"domain","role":"reader","domain":"example.com"}'

# Remove sharing permission
gws drive permissions delete --params '{"fileId":"FILE_ID","permissionId":"PERMISSION_ID"}'

# Transfer ownership
gws drive permissions create --params '{"fileId":"FILE_ID","transferOwnership":true}' --json '{"type":"user","role":"owner","emailAddress":"newowner@example.com"}'
```

### Permission Roles

| Role          | Description                              |
| ------------- | ---------------------------------------- |
| `owner`       | Full control, can transfer ownership     |
| `organizer`   | Shared drive: manage members and content |
| `writer`      | Edit, comment, share                     |
| `commenter`   | View and comment                         |
| `reader`      | View only                                |

## Revisions

```bash
# List revisions
gws drive revisions list --params '{"fileId":"FILE_ID"}'

# Get a specific revision
gws drive revisions get --params '{"fileId":"FILE_ID","revisionId":"REVISION_ID"}'

# Download a specific revision
gws drive revisions get --params '{"fileId":"FILE_ID","revisionId":"REVISION_ID","alt":"media"}' > old_version.pdf
```

## Shared Drives

```bash
# List shared drives
gws drive drives list --params '{"pageSize":10}'

# Create a shared drive
gws drive drives create --params '{"requestId":"unique-request-id"}' --json '{"name":"Team Drive"}'

# List files in a shared drive
gws drive files list --params '{"driveId":"DRIVE_ID","corpora":"drive","includeItemsFromAllDrives":true,"supportsAllDrives":true,"pageSize":20}'
```

## Comments

```bash
# List comments on a file
gws drive comments list --params '{"fileId":"FILE_ID"}'

# Add a comment
gws drive comments create --params '{"fileId":"FILE_ID"}' --json '{"content":"Please review this section."}'

# Reply to a comment
gws drive replies create --params '{"fileId":"FILE_ID","commentId":"COMMENT_ID"}' --json '{"content":"Done, updated."}'
```
