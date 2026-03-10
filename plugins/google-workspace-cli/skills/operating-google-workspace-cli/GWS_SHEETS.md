# gws Sheets Operations

Complete reference for Google Sheets operations via the `gws` CLI.

## Prerequisites

```bash
gws auth login --scopes sheets
```

## Shell Quoting Warning

**Always quote ranges containing `!` in single quotes** to prevent bash history expansion:

```bash
# Correct
--params '{"range":"Sheet1!A1:C10"}'

# WRONG — bash interprets ! as history expansion
--params "{"range":"Sheet1!A1:C10"}"
```

## Create Spreadsheet

```bash
# Create empty spreadsheet
gws sheets spreadsheets create --json '{"properties":{"title":"My Spreadsheet"}}'

# Create with initial sheet name
gws sheets spreadsheets create --json '{
  "properties": {"title": "Sales Report"},
  "sheets": [{"properties": {"title": "Q1"}}, {"properties": {"title": "Q2"}}]
}'

# Capture spreadsheet ID
SHEET_ID=$(gws sheets spreadsheets create --json '{"properties":{"title":"New Sheet"}}' | jq -r '.spreadsheetId')
```

## Read Values

```bash
# Read a range
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C10"}'

# Read entire sheet
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1"}'

# Read a single cell
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1"}'

# Read with value render option
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C10","valueRenderOption":"FORMATTED_VALUE"}'

# Read with date/time render option
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C10","dateTimeRenderOption":"FORMATTED_STRING"}'

# Extract just the values with jq
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C10"}' | jq -r '.values[]'
```

### Value Render Options

| Option              | Description                                    |
| ------------------- | ---------------------------------------------- |
| `FORMATTED_VALUE`   | Values as displayed in the UI (with formatting)|
| `UNFORMATTED_VALUE` | Raw values without formatting                  |
| `FORMULA`           | Formulas instead of calculated values          |

## Write Values

```bash
# Write to a range
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C1","valueInputOption":"USER_ENTERED"}' \
  --json '{"values":[["Name","Age","City"]]}'

# Write multiple rows
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C3","valueInputOption":"USER_ENTERED"}' \
  --json '{"values":[["Name","Age","City"],["Alice","30","Taipei"],["Bob","25","Tokyo"]]}'

# Write with RAW input (no parsing of dates/numbers)
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1","valueInputOption":"RAW"}' \
  --json '{"values":[["=SUM(B1:B10)"]]}'

# Write formulas
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!D1","valueInputOption":"USER_ENTERED"}' \
  --json '{"values":[["=SUM(B2:B100)"],["=AVERAGE(B2:B100)"],["=COUNT(B2:B100)"]]}'
```

### Value Input Options

| Option         | Description                                           |
| -------------- | ----------------------------------------------------- |
| `RAW`          | Values stored as-is (no parsing)                      |
| `USER_ENTERED` | Values parsed as if typed in UI (formulas, dates)     |

## Append Rows

```bash
# Append a single row
gws sheets spreadsheets values append \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1","valueInputOption":"USER_ENTERED"}' \
  --json '{"values":[["New Entry","42","2025-01-15"]]}'

# Append multiple rows
gws sheets spreadsheets values append \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1","valueInputOption":"USER_ENTERED","insertDataOption":"INSERT_ROWS"}' \
  --json '{"values":[["Row1","data1"],["Row2","data2"],["Row3","data3"]]}'
```

### Insert Data Options

| Option              | Description                                   |
| ------------------- | --------------------------------------------- |
| `OVERWRITE`         | Overwrite existing data at target range        |
| `INSERT_ROWS`       | Insert new rows for the data                   |

## Clear Values

```bash
# Clear a range
gws sheets spreadsheets values clear \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C10"}'

# Clear entire sheet
gws sheets spreadsheets values clear \
  --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1"}'
```

## Batch Operations

```bash
# Batch read multiple ranges
gws sheets spreadsheets values batchGet \
  --params '{"spreadsheetId":"SHEET_ID","ranges":["Sheet1!A1:B5","Sheet1!D1:E5","Sheet2!A1:C3"]}'

# Batch update multiple ranges
gws sheets spreadsheets values batchUpdate \
  --params '{"spreadsheetId":"SHEET_ID"}' \
  --json '{
    "valueInputOption": "USER_ENTERED",
    "data": [
      {"range": "Sheet1!A1:B1", "values": [["Header1", "Header2"]]},
      {"range": "Sheet1!A2:B3", "values": [["val1", "val2"], ["val3", "val4"]]},
      {"range": "Sheet2!A1", "values": [["Sheet2 Data"]]}
    ]
  }'

# Batch clear multiple ranges
gws sheets spreadsheets values batchClear \
  --params '{"spreadsheetId":"SHEET_ID"}' \
  --json '{"ranges":["Sheet1!A1:B5","Sheet2!A1:C3"]}'
```

## Sheet Management (batchUpdate requests)

```bash
# Add a new sheet
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{"addSheet": {"properties": {"title": "New Sheet", "index": 1}}}]
}'

# Rename a sheet
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{"updateSheetProperties": {"properties": {"sheetId": 0, "title": "Renamed Sheet"}, "fields": "title"}}]
}'

# Delete a sheet
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{"deleteSheet": {"sheetId": SHEET_GID}}]
}'

# Duplicate a sheet
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{"duplicateSheet": {"sourceSheetId": 0, "newSheetName": "Copy of Sheet1"}}]
}'

# Hide a sheet
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{"updateSheetProperties": {"properties": {"sheetId": 0, "hidden": true}, "fields": "hidden"}}]
}'
```

## Formatting

```bash
# Bold header row
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "repeatCell": {
      "range": {"sheetId": 0, "startRowIndex": 0, "endRowIndex": 1},
      "cell": {"userEnteredFormat": {"textFormat": {"bold": true}}},
      "fields": "userEnteredFormat.textFormat.bold"
    }
  }]
}'

# Set background color
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "repeatCell": {
      "range": {"sheetId": 0, "startRowIndex": 0, "endRowIndex": 1},
      "cell": {"userEnteredFormat": {"backgroundColor": {"red": 0.2, "green": 0.6, "blue": 0.9}}},
      "fields": "userEnteredFormat.backgroundColor"
    }
  }]
}'

# Auto-resize columns
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "autoResizeDimensions": {
      "dimensions": {"sheetId": 0, "dimension": "COLUMNS", "startIndex": 0, "endIndex": 5}
    }
  }]
}'

# Freeze header row
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "updateSheetProperties": {
      "properties": {"sheetId": 0, "gridProperties": {"frozenRowCount": 1}},
      "fields": "gridProperties.frozenRowCount"
    }
  }]
}'

# Add borders
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "updateBorders": {
      "range": {"sheetId": 0, "startRowIndex": 0, "endRowIndex": 10, "startColumnIndex": 0, "endColumnIndex": 5},
      "top": {"style": "SOLID", "color": {"red": 0, "green": 0, "blue": 0}},
      "bottom": {"style": "SOLID", "color": {"red": 0, "green": 0, "blue": 0}},
      "left": {"style": "SOLID", "color": {"red": 0, "green": 0, "blue": 0}},
      "right": {"style": "SOLID", "color": {"red": 0, "green": 0, "blue": 0}},
      "innerHorizontal": {"style": "SOLID", "color": {"red": 0.8, "green": 0.8, "blue": 0.8}},
      "innerVertical": {"style": "SOLID", "color": {"red": 0.8, "green": 0.8, "blue": 0.8}}
    }
  }]
}'

# Number formatting (currency)
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "repeatCell": {
      "range": {"sheetId": 0, "startRowIndex": 1, "endRowIndex": 100, "startColumnIndex": 2, "endColumnIndex": 3},
      "cell": {"userEnteredFormat": {"numberFormat": {"type": "CURRENCY", "pattern": "$#,##0.00"}}},
      "fields": "userEnteredFormat.numberFormat"
    }
  }]
}'
```

## Conditional Formatting

```bash
# Highlight cells greater than a value
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "addConditionalFormatRule": {
      "rule": {
        "ranges": [{"sheetId": 0, "startRowIndex": 1, "endRowIndex": 100, "startColumnIndex": 1, "endColumnIndex": 2}],
        "booleanRule": {
          "condition": {"type": "NUMBER_GREATER", "values": [{"userEnteredValue": "100"}]},
          "format": {"backgroundColor": {"red": 0.8, "green": 1, "blue": 0.8}}
        }
      },
      "index": 0
    }
  }]
}'
```

## Data Validation

```bash
# Dropdown list validation
gws sheets spreadsheets batchUpdate --params '{"spreadsheetId":"SHEET_ID"}' --json '{
  "requests": [{
    "setDataValidation": {
      "range": {"sheetId": 0, "startRowIndex": 1, "endRowIndex": 100, "startColumnIndex": 3, "endColumnIndex": 4},
      "rule": {
        "condition": {"type": "ONE_OF_LIST", "values": [{"userEnteredValue": "Active"}, {"userEnteredValue": "Inactive"}, {"userEnteredValue": "Pending"}]},
        "showCustomUi": true,
        "strict": true
      }
    }
  }]
}'
```

## Get Spreadsheet Metadata

```bash
# Get spreadsheet properties
gws sheets spreadsheets get --params '{"spreadsheetId":"SHEET_ID"}'

# Get sheet names and IDs
gws sheets spreadsheets get --params '{"spreadsheetId":"SHEET_ID","fields":"sheets.properties"}' \
  | jq '.sheets[].properties | {sheetId, title}'
```
