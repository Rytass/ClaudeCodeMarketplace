# gws Chat Operations

Complete reference for Google Chat operations via the `gws` CLI.

## Prerequisites

```bash
gws auth login --scopes chat
```

**Note**: Google Chat API requires a Google Workspace account (not consumer Gmail). For Chat apps/bots, you need a GCP project with Chat API enabled and a configured Chat app.

## Spaces

```bash
# List all spaces (DMs, group chats, and spaces)
gws chat spaces list

# List with page size
gws chat spaces list --params '{"pageSize":20}'

# Get all spaces (paginated)
gws chat spaces list --page-all

# Get a specific space
gws chat spaces get --params '{"name":"spaces/SPACE_ID"}'

# Search spaces by display name
gws chat spaces search --params '{"query":"displayName:\"Engineering Team\"","pageSize":10}'

# Create a space
gws chat spaces create --json '{
  "displayName": "Project Alpha",
  "spaceType": "SPACE",
  "singleUserBotDm": false
}'

# Update space details
gws chat spaces patch --params '{"name":"spaces/SPACE_ID","updateMask":"displayName,spaceDetails"}' --json '{
  "displayName": "Updated Space Name",
  "spaceDetails": {"description": "Updated description"}
}'

# Delete a space
gws chat spaces delete --params '{"name":"spaces/SPACE_ID"}'
```

### Space Types

| Type      | Description                              |
| --------- | ---------------------------------------- |
| `SPACE`   | Named space (visible in sidebar)         |
| `GROUP_CHAT` | Group direct message                 |
| `DIRECT_MESSAGE` | 1:1 direct message               |

## Messages

```bash
# List messages in a space
gws chat spaces messages list --params '{"parent":"spaces/SPACE_ID","pageSize":25}'

# List all messages (paginated)
gws chat spaces messages list --params '{"parent":"spaces/SPACE_ID"}' --page-all

# Get a specific message
gws chat spaces messages get --params '{"name":"spaces/SPACE_ID/messages/MESSAGE_ID"}'

# Send a plain text message
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "text": "Hello, team! Here is a quick update."
}'

# Send a message with formatted text (Google Chat markup)
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "text": "*Bold text* _italic text_ ~strikethrough~ `inline code`\n\n```\ncode block\n```"
}'

# Reply to a thread
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID","messageReplyOption":"REPLY_MESSAGE_FALLBACK_TO_NEW_THREAD"}' --json '{
  "text": "This is a threaded reply.",
  "thread": {"name": "spaces/SPACE_ID/threads/THREAD_ID"}
}'

# Start a new thread with a name
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "text": "Starting a new discussion thread.",
  "thread": {"threadKey": "project-alpha-updates"}
}'

# Send a message with a card
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "cardsV2": [{
    "cardId": "status-card",
    "card": {
      "header": {"title": "Build Status", "subtitle": "CI/CD Pipeline", "imageUrl": "https://example.com/icon.png"},
      "sections": [{
        "header": "Results",
        "widgets": [
          {"decoratedText": {"topLabel": "Status", "text": "Passed", "icon": {"knownIcon": "STAR"}}},
          {"decoratedText": {"topLabel": "Duration", "text": "3m 42s"}},
          {"buttonList": {"buttons": [{"text": "View Details", "onClick": {"openLink": {"url": "https://ci.example.com/build/123"}}}]}}
        ]
      }]
    }
  }]
}'

# Update a message
gws chat spaces messages patch --params '{"name":"spaces/SPACE_ID/messages/MESSAGE_ID","updateMask":"text"}' --json '{
  "text": "Updated message content."
}'

# Delete a message
gws chat spaces messages delete --params '{"name":"spaces/SPACE_ID/messages/MESSAGE_ID"}'
```

## Reactions

```bash
# Add a reaction to a message
gws chat spaces messages reactions create --params '{"parent":"spaces/SPACE_ID/messages/MESSAGE_ID"}' --json '{
  "emoji": {"unicode": "👍"}
}'

# List reactions on a message
gws chat spaces messages reactions list --params '{"parent":"spaces/SPACE_ID/messages/MESSAGE_ID"}'

# Delete a reaction
gws chat spaces messages reactions delete --params '{"name":"spaces/SPACE_ID/messages/MESSAGE_ID/reactions/REACTION_ID"}'
```

## Membership

```bash
# List members of a space
gws chat spaces members list --params '{"parent":"spaces/SPACE_ID"}'

# Get a specific member
gws chat spaces members get --params '{"name":"spaces/SPACE_ID/members/MEMBER_ID"}'

# Add a member to a space (human user)
gws chat spaces members create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "member": {"name": "users/USER_ID", "type": "HUMAN"}
}'

# Remove a member
gws chat spaces members delete --params '{"name":"spaces/SPACE_ID/members/MEMBER_ID"}'
```

## Attachments

```bash
# Get attachment metadata
gws chat media download --params '{"resourceName":"spaces/SPACE_ID/messages/MESSAGE_ID/attachments/ATTACHMENT_ID"}'
```

## User Mentions

Use `<users/USER_ID>` in message text to @mention users:

```bash
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "text": "Hey <users/123456>, can you review this?"
}'

# Mention all (@all)
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "text": "Attention <users/all>: Deployment scheduled for tonight."
}'
```

## Action Items Workflow

```bash
# 1. List recent messages from a space
gws chat spaces messages list --params '{"parent":"spaces/SPACE_ID","pageSize":50}'

# 2. Search for action items (filter messages containing keywords)
# Process with jq to find messages containing "TODO", "action item", etc.

# 3. Post a summary card
gws chat spaces messages create --params '{"parent":"spaces/SPACE_ID"}' --json '{
  "text": "*Action Items from today:*\n1. Review PR #42 — @alice\n2. Update docs — @bob\n3. Deploy to staging — @charlie"
}'
```
