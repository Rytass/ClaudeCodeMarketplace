# gws Docs Operations

Complete reference for Google Docs operations via the `gws` CLI.

## Prerequisites

```bash
gws auth login --scopes docs
```

## Create Document

```bash
# Create empty document
gws docs documents create --json '{"title":"My Document"}'

# Capture document ID
DOC_ID=$(gws docs documents create --json '{"title":"New Document"}' | jq -r '.documentId')
```

## Get Document

```bash
# Get full document content
gws docs documents get --params '{"documentId":"DOC_ID"}'

# Get document title
gws docs documents get --params '{"documentId":"DOC_ID"}' | jq -r '.title'

# Get document body text
gws docs documents get --params '{"documentId":"DOC_ID"}' | jq -r '.body.content[].paragraph.elements[].textRun.content // empty'
```

## Insert Text

```bash
# Insert text at the beginning (index 1)
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{"insertText": {"location": {"index": 1}, "text": "Hello, World!\n"}}]
}'

# Insert text at a specific position
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{"insertText": {"location": {"index": 25}, "text": "Inserted text here."}}]
}'

# Insert text at the end of document
# First get the document length, then insert at that index
DOC_LENGTH=$(gws docs documents get --params '{"documentId":"DOC_ID"}' | jq '.body.content[-1].endIndex')
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json "{
  \"requests\": [{\"insertText\": {\"location\": {\"index\": $((DOC_LENGTH - 1))}, \"text\": \"\nAppended text.\"}}]
}"
```

## Delete Text

```bash
# Delete a range of text
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{"deleteContentRange": {"range": {"startIndex": 1, "endIndex": 15}}}]
}'
```

## Replace Text

```bash
# Find and replace all occurrences
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "replaceAllText": {
      "containsText": {"text": "old text", "matchCase": false},
      "replaceText": "new text"
    }
  }]
}'

# Case-sensitive replace
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "replaceAllText": {
      "containsText": {"text": "OldText", "matchCase": true},
      "replaceText": "NewText"
    }
  }]
}'
```

## Formatting

```bash
# Bold text
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "updateTextStyle": {
      "range": {"startIndex": 1, "endIndex": 14},
      "textStyle": {"bold": true},
      "fields": "bold"
    }
  }]
}'

# Italic text
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "updateTextStyle": {
      "range": {"startIndex": 1, "endIndex": 14},
      "textStyle": {"italic": true},
      "fields": "italic"
    }
  }]
}'

# Change font size
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "updateTextStyle": {
      "range": {"startIndex": 1, "endIndex": 14},
      "textStyle": {"fontSize": {"magnitude": 18, "unit": "PT"}},
      "fields": "fontSize"
    }
  }]
}'

# Change font color
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "updateTextStyle": {
      "range": {"startIndex": 1, "endIndex": 14},
      "textStyle": {"foregroundColor": {"color": {"rgbColor": {"red": 0.8, "green": 0, "blue": 0}}}},
      "fields": "foregroundColor"
    }
  }]
}'

# Change font family
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "updateTextStyle": {
      "range": {"startIndex": 1, "endIndex": 14},
      "textStyle": {"weightedFontFamily": {"fontFamily": "Roboto Mono"}},
      "fields": "weightedFontFamily"
    }
  }]
}'

# Apply heading style
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "updateParagraphStyle": {
      "range": {"startIndex": 1, "endIndex": 14},
      "paragraphStyle": {"namedStyleType": "HEADING_1"},
      "fields": "namedStyleType"
    }
  }]
}'
```

### Named Style Types

| Style Type    | Description      |
| ------------- | ---------------- |
| `NORMAL_TEXT` | Normal paragraph |
| `HEADING_1`   | Heading 1        |
| `HEADING_2`   | Heading 2        |
| `HEADING_3`   | Heading 3        |
| `HEADING_4`   | Heading 4        |
| `HEADING_5`   | Heading 5        |
| `HEADING_6`   | Heading 6        |
| `TITLE`       | Title            |
| `SUBTITLE`    | Subtitle         |

## Lists

```bash
# Create a bulleted list
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "createParagraphBullets": {
      "range": {"startIndex": 1, "endIndex": 50},
      "bulletPreset": "BULLET_DISC_CIRCLE_SQUARE"
    }
  }]
}'

# Create a numbered list
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "createParagraphBullets": {
      "range": {"startIndex": 1, "endIndex": 50},
      "bulletPreset": "NUMBERED_DECIMAL_ALPHA_ROMAN"
    }
  }]
}'

# Remove bullets
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{"deleteParagraphBullets": {"range": {"startIndex": 1, "endIndex": 50}}}]
}'
```

## Tables

```bash
# Insert a table (3 rows x 4 columns)
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "insertTable": {
      "location": {"index": 1},
      "rows": 3,
      "columns": 4
    }
  }]
}'

# Insert text into a table cell (must know the cell's start index)
# Get the document structure first to find cell indices
gws docs documents get --params '{"documentId":"DOC_ID"}' | jq '.body.content[] | select(.table)'

# Delete a table row
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "deleteTableRow": {
      "tableCellLocation": {
        "tableStartLocation": {"index": TABLE_START_INDEX},
        "rowIndex": 2,
        "columnIndex": 0
      }
    }
  }]
}'

# Delete a table column
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "deleteTableColumn": {
      "tableCellLocation": {
        "tableStartLocation": {"index": TABLE_START_INDEX},
        "rowIndex": 0,
        "columnIndex": 3
      }
    }
  }]
}'
```

## Images

```bash
# Insert image by URL
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "insertInlineImage": {
      "location": {"index": 1},
      "uri": "https://example.com/image.png",
      "objectSize": {
        "width": {"magnitude": 300, "unit": "PT"},
        "height": {"magnitude": 200, "unit": "PT"}
      }
    }
  }]
}'
```

## Page Breaks

```bash
# Insert a page break
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{"insertPageBreak": {"location": {"index": 50}}}]
}'
```

## Multiple Operations in One Request

```bash
# Combine multiple operations (executed in order)
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [
    {"insertText": {"location": {"index": 1}, "text": "Document Title\n\nFirst paragraph content.\n\nSecond paragraph.\n"}},
    {"updateParagraphStyle": {"range": {"startIndex": 1, "endIndex": 16}, "paragraphStyle": {"namedStyleType": "HEADING_1"}, "fields": "namedStyleType"}},
    {"updateTextStyle": {"range": {"startIndex": 1, "endIndex": 16}, "textStyle": {"bold": true}, "fields": "bold"}}
  ]
}'
```

**Important**: When combining requests, indices refer to the state of the document _before_ any request in the batch executes. Process requests that reference later indices first, or adjust indices accounting for insertions/deletions.

## Named Ranges

```bash
# Create a named range
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{
    "createNamedRange": {
      "name": "my-section",
      "range": {"startIndex": 10, "endIndex": 50}
    }
  }]
}'

# Delete a named range
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{
  "requests": [{"deleteNamedRange": {"name": "my-section"}}]
}'
```

## Document Structure Navigation

```bash
# Get all headings
gws docs documents get --params '{"documentId":"DOC_ID"}' \
  | jq '[.body.content[] | select(.paragraph.paragraphStyle.namedStyleType | test("HEADING")) | {style: .paragraph.paragraphStyle.namedStyleType, text: [.paragraph.elements[].textRun.content] | join("")}]'

# Get document word count (approximate)
gws docs documents get --params '{"documentId":"DOC_ID"}' \
  | jq '[.body.content[].paragraph.elements[]?.textRun.content // empty] | join("") | split(" ") | length'
```
