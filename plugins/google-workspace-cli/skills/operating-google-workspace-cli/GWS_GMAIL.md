# gws Gmail Operations

Complete reference for all Gmail operations via the `gws` CLI.

## Prerequisites

```bash
gws auth login --scopes gmail
```

## List & Search Messages

```bash
# List recent messages
gws gmail users messages list --params '{"userId":"me","maxResults":10}'

# Search with Gmail query syntax
gws gmail users messages list --params '{"userId":"me","q":"is:unread","maxResults":20}'

# Search by sender
gws gmail users messages list --params '{"userId":"me","q":"from:alice@example.com"}'

# Search by date range
gws gmail users messages list --params '{"userId":"me","q":"after:2025/01/01 before:2025/02/01"}'

# Search with multiple criteria
gws gmail users messages list --params '{"userId":"me","q":"from:boss@company.com has:attachment subject:report"}'

# Search in specific label
gws gmail users messages list --params '{"userId":"me","q":"label:work is:unread"}'

# Paginate all results
gws gmail users messages list --params '{"userId":"me","q":"is:starred"}' --page-all
```

### Common Gmail Search Operators

| Operator                  | Example                        | Description                    |
| ------------------------- | ------------------------------ | ------------------------------ |
| `from:`                   | `from:alice@example.com`       | Sender                         |
| `to:`                     | `to:bob@example.com`           | Recipient                      |
| `subject:`                | `subject:meeting`              | Subject line                   |
| `has:attachment`          | `has:attachment`               | Has attachments                |
| `filename:`               | `filename:pdf`                 | Attachment filename            |
| `is:unread`               | `is:unread`                    | Unread messages                |
| `is:starred`              | `is:starred`                   | Starred messages               |
| `is:important`            | `is:important`                 | Important messages             |
| `label:`                  | `label:work`                   | Has label                      |
| `after:` / `before:`      | `after:2025/01/01`             | Date range                     |
| `newer_than:` / `older_than:` | `newer_than:7d`           | Relative date (d, m, y)        |
| `larger:` / `smaller:`    | `larger:5M`                    | Message size                   |
| `in:anywhere`             | `in:anywhere`                  | All mail including trash/spam  |

## Read Message

```bash
# Get message by ID (metadata only)
gws gmail users messages get --params '{"userId":"me","id":"MSG_ID"}'

# Get full message with body
gws gmail users messages get --params '{"userId":"me","id":"MSG_ID","format":"full"}'

# Get raw message (RFC 2822)
gws gmail users messages get --params '{"userId":"me","id":"MSG_ID","format":"raw"}'

# Get only metadata headers
gws gmail users messages get --params '{"userId":"me","id":"MSG_ID","format":"metadata","metadataHeaders":["From","To","Subject","Date"]}'
```

### Extract Message Content with jq

```bash
# Get subject from message
gws gmail users messages get --params '{"userId":"me","id":"MSG_ID","format":"metadata","metadataHeaders":["Subject"]}' \
  | jq -r '.payload.headers[] | select(.name=="Subject") | .value'

# Get snippet (preview text)
gws gmail users messages get --params '{"userId":"me","id":"MSG_ID"}' | jq -r '.snippet'
```

## Send Email

Emails must be sent as Base64url-encoded RFC 2822 messages.

### Helper: Construct and Send

```bash
# Build RFC 2822 message and base64url encode
RAW=$(printf 'From: me\r\nTo: recipient@example.com\r\nSubject: Hello from CLI\r\nContent-Type: text/plain; charset=utf-8\r\n\r\nThis is the email body.' | base64 -w 0 | tr '+/' '-_' | tr -d '=')

# Send
gws gmail users messages send --params '{"userId":"me"}' --json "{\"raw\":\"$RAW\"}"
```

### Send HTML Email

```bash
RAW=$(printf 'From: me\r\nTo: recipient@example.com\r\nSubject: HTML Email\r\nContent-Type: text/html; charset=utf-8\r\n\r\n<h1>Hello</h1><p>This is an <b>HTML</b> email.</p>' | base64 -w 0 | tr '+/' '-_' | tr -d '=')

gws gmail users messages send --params '{"userId":"me"}' --json "{\"raw\":\"$RAW\"}"
```

### Send with CC/BCC

```bash
RAW=$(printf 'From: me\r\nTo: to@example.com\r\nCc: cc@example.com\r\nBcc: bcc@example.com\r\nSubject: With CC and BCC\r\nContent-Type: text/plain; charset=utf-8\r\n\r\nBody text.' | base64 -w 0 | tr '+/' '-_' | tr -d '=')

gws gmail users messages send --params '{"userId":"me"}' --json "{\"raw\":\"$RAW\"}"
```

## Reply to a Message

```bash
# Get the original message's threadId and Message-ID header
THREAD_ID=$(gws gmail users messages get --params '{"userId":"me","id":"ORIG_MSG_ID"}' | jq -r '.threadId')
MSG_ID_HEADER=$(gws gmail users messages get --params '{"userId":"me","id":"ORIG_MSG_ID","format":"metadata","metadataHeaders":["Message-Id"]}' | jq -r '.payload.headers[] | select(.name=="Message-Id") | .value')

# Build reply with In-Reply-To and References headers
RAW=$(printf "From: me\r\nTo: original-sender@example.com\r\nSubject: Re: Original Subject\r\nIn-Reply-To: $MSG_ID_HEADER\r\nReferences: $MSG_ID_HEADER\r\nContent-Type: text/plain; charset=utf-8\r\n\r\nReply body here." | base64 -w 0 | tr '+/' '-_' | tr -d '=')

gws gmail users messages send --params '{"userId":"me"}' --json "{\"raw\":\"$RAW\",\"threadId\":\"$THREAD_ID\"}"
```

## Forward a Message

```bash
# Get original message content, construct new message with original content
# and send to the new recipient with "Fwd:" prefix in subject
```

## Drafts

```bash
# List drafts
gws gmail users drafts list --params '{"userId":"me"}'

# Create a draft
RAW=$(printf 'From: me\r\nTo: recipient@example.com\r\nSubject: Draft Subject\r\nContent-Type: text/plain; charset=utf-8\r\n\r\nDraft body.' | base64 -w 0 | tr '+/' '-_' | tr -d '=')

gws gmail users drafts create --params '{"userId":"me"}' --json "{\"message\":{\"raw\":\"$RAW\"}}"

# Get a draft
gws gmail users drafts get --params '{"userId":"me","id":"DRAFT_ID"}'

# Send a draft
gws gmail users drafts send --params '{"userId":"me"}' --json '{"id":"DRAFT_ID"}'

# Update a draft
gws gmail users drafts update --params '{"userId":"me","id":"DRAFT_ID"}' --json "{\"message\":{\"raw\":\"$NEW_RAW\"}}"

# Delete a draft
gws gmail users drafts delete --params '{"userId":"me","id":"DRAFT_ID"}'
```

## Labels

```bash
# List all labels
gws gmail users labels list --params '{"userId":"me"}'

# Create a label
gws gmail users labels create --params '{"userId":"me"}' --json '{"name":"MyLabel","labelListVisibility":"labelShow","messageListVisibility":"show"}'

# Create nested label
gws gmail users labels create --params '{"userId":"me"}' --json '{"name":"Projects/ClientA"}'

# Update a label
gws gmail users labels update --params '{"userId":"me","id":"LABEL_ID"}' --json '{"name":"NewLabelName"}'

# Delete a label
gws gmail users labels delete --params '{"userId":"me","id":"LABEL_ID"}'

# Add label to message
gws gmail users messages modify --params '{"userId":"me","id":"MSG_ID"}' --json '{"addLabelIds":["LABEL_ID"]}'

# Remove label from message
gws gmail users messages modify --params '{"userId":"me","id":"MSG_ID"}' --json '{"removeLabelIds":["LABEL_ID"]}'

# Mark as read (remove UNREAD label)
gws gmail users messages modify --params '{"userId":"me","id":"MSG_ID"}' --json '{"removeLabelIds":["UNREAD"]}'

# Mark as unread
gws gmail users messages modify --params '{"userId":"me","id":"MSG_ID"}' --json '{"addLabelIds":["UNREAD"]}'

# Star a message
gws gmail users messages modify --params '{"userId":"me","id":"MSG_ID"}' --json '{"addLabelIds":["STARRED"]}'

# Archive (remove INBOX label)
gws gmail users messages modify --params '{"userId":"me","id":"MSG_ID"}' --json '{"removeLabelIds":["INBOX"]}'
```

## Batch Modify Messages

```bash
# Batch modify multiple messages
gws gmail users messages batchModify --params '{"userId":"me"}' --json '{"ids":["MSG_ID_1","MSG_ID_2","MSG_ID_3"],"addLabelIds":["LABEL_ID"],"removeLabelIds":["UNREAD"]}'

# Batch delete (moves to trash)
gws gmail users messages batchDelete --params '{"userId":"me"}' --json '{"ids":["MSG_ID_1","MSG_ID_2"]}'
```

## Trash & Delete

```bash
# Move to trash
gws gmail users messages trash --params '{"userId":"me","id":"MSG_ID"}'

# Remove from trash
gws gmail users messages untrash --params '{"userId":"me","id":"MSG_ID"}'

# Permanently delete (irreversible!)
gws gmail users messages delete --params '{"userId":"me","id":"MSG_ID"}'
```

## Threads

```bash
# List threads
gws gmail users threads list --params '{"userId":"me","maxResults":10}'

# Get a thread (all messages in conversation)
gws gmail users threads get --params '{"userId":"me","id":"THREAD_ID"}'

# Search threads
gws gmail users threads list --params '{"userId":"me","q":"subject:project-update"}'

# Trash a thread
gws gmail users threads trash --params '{"userId":"me","id":"THREAD_ID"}'

# Modify thread labels
gws gmail users threads modify --params '{"userId":"me","id":"THREAD_ID"}' --json '{"addLabelIds":["LABEL_ID"]}'
```

## Filters

```bash
# List filters
gws gmail users settings filters list --params '{"userId":"me"}'

# Create a filter (auto-label emails from a sender)
gws gmail users settings filters create --params '{"userId":"me"}' --json '{
  "criteria": {"from": "notifications@github.com"},
  "action": {"addLabelIds": ["LABEL_ID"], "removeLabelIds": ["INBOX"]}
}'

# Create filter to auto-star important emails
gws gmail users settings filters create --params '{"userId":"me"}' --json '{
  "criteria": {"from": "ceo@company.com"},
  "action": {"addLabelIds": ["STARRED", "IMPORTANT"]}
}'

# Delete a filter
gws gmail users settings filters delete --params '{"userId":"me","id":"FILTER_ID"}'
```

## Settings

```bash
# Get auto-forwarding settings
gws gmail users settings getAutoForwarding --params '{"userId":"me"}'

# Get IMAP settings
gws gmail users settings getImap --params '{"userId":"me"}'

# Get POP settings
gws gmail users settings getPop --params '{"userId":"me"}'

# Get vacation (out-of-office) settings
gws gmail users settings getVacation --params '{"userId":"me"}'

# Set vacation responder
gws gmail users settings updateVacation --params '{"userId":"me"}' --json '{
  "enableAutoReply": true,
  "responseSubject": "Out of Office",
  "responseBodyHtml": "<p>I am currently out of the office.</p>",
  "startTime": 1704067200000,
  "endTime": 1704672000000
}'

# Disable vacation responder
gws gmail users settings updateVacation --params '{"userId":"me"}' --json '{"enableAutoReply": false}'
```

## Send-As & Signatures

```bash
# List send-as aliases
gws gmail users settings sendAs list --params '{"userId":"me"}'

# Get signature
gws gmail users settings sendAs get --params '{"userId":"me","sendAsEmail":"user@example.com"}' | jq -r '.signature'

# Update signature
gws gmail users settings sendAs update --params '{"userId":"me","sendAsEmail":"user@example.com"}' --json '{"signature":"<b>John Doe</b><br>Software Engineer"}'
```

## Attachments

```bash
# Get attachment data
gws gmail users messages attachments get --params '{"userId":"me","messageId":"MSG_ID","id":"ATTACHMENT_ID"}'

# The attachment data is base64-encoded in the response
# Decode: response | jq -r '.data' | base64 -d > filename
```

## Email Triage Workflow

Efficient unread email processing pattern:

```bash
# 1. List unread messages
gws gmail users messages list --params '{"userId":"me","q":"is:unread","maxResults":25}'

# 2. Get details for each (extract subject, sender, snippet)
# Loop through message IDs and fetch metadata

# 3. Categorize and act:
#    - Star important ones
#    - Label by category
#    - Archive newsletters
#    - Mark as read after processing
```
