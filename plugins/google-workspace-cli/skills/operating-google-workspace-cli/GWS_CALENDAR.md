# gws Calendar Operations

Complete reference for Google Calendar operations via the `gws` CLI.

## Prerequisites

```bash
gws auth login --scopes calendar
```

## List Calendars

```bash
# List all calendars
gws calendar calendarList list

# List calendars with details
gws calendar calendarList list | jq '.items[] | {id, summary, accessRole}'

# Get a specific calendar
gws calendar calendarList get --params '{"calendarId":"primary"}'
```

## View Agenda (List Events)

```bash
# List upcoming events
gws calendar events list --params '{"calendarId":"primary","timeMin":"2025-01-01T00:00:00Z","maxResults":10,"singleEvents":true,"orderBy":"startTime"}'

# Today's events
gws calendar events list --params '{"calendarId":"primary","timeMin":"2025-01-15T00:00:00Z","timeMax":"2025-01-16T00:00:00Z","singleEvents":true,"orderBy":"startTime"}'

# This week's events
gws calendar events list --params '{"calendarId":"primary","timeMin":"2025-01-13T00:00:00Z","timeMax":"2025-01-20T00:00:00Z","singleEvents":true,"orderBy":"startTime"}'

# Search events by text
gws calendar events list --params '{"calendarId":"primary","q":"standup","singleEvents":true,"orderBy":"startTime","maxResults":10}'

# List events from a specific calendar
gws calendar events list --params '{"calendarId":"calendar-id@group.calendar.google.com","timeMin":"2025-01-01T00:00:00Z","maxResults":20,"singleEvents":true,"orderBy":"startTime"}'

# Get all events (paginated)
gws calendar events list --params '{"calendarId":"primary","singleEvents":true,"orderBy":"startTime"}' --page-all
```

### Extract Event Details with jq

```bash
# Pretty agenda view
gws calendar events list --params '{"calendarId":"primary","timeMin":"2025-01-15T00:00:00Z","timeMax":"2025-01-16T00:00:00Z","singleEvents":true,"orderBy":"startTime"}' \
  | jq -r '.items[] | "\(.start.dateTime // .start.date) - \(.summary)"'
```

## Create Events

```bash
# Create a timed event
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Team Meeting",
  "description": "Weekly team sync",
  "location": "Conference Room A",
  "start": {"dateTime": "2025-01-15T10:00:00+08:00", "timeZone": "Asia/Taipei"},
  "end": {"dateTime": "2025-01-15T11:00:00+08:00", "timeZone": "Asia/Taipei"}
}'

# Create an all-day event
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Company Holiday",
  "start": {"date": "2025-01-01"},
  "end": {"date": "2025-01-02"}
}'

# Create event with attendees
gws calendar events insert --params '{"calendarId":"primary","sendUpdates":"all"}' --json '{
  "summary": "Project Review",
  "start": {"dateTime": "2025-01-15T14:00:00+08:00"},
  "end": {"dateTime": "2025-01-15T15:00:00+08:00"},
  "attendees": [
    {"email": "alice@example.com"},
    {"email": "bob@example.com"},
    {"email": "charlie@example.com", "optional": true}
  ]
}'

# Create event with Google Meet link
gws calendar events insert --params '{"calendarId":"primary","conferenceDataVersion":1}' --json '{
  "summary": "Virtual Standup",
  "start": {"dateTime": "2025-01-15T09:00:00+08:00"},
  "end": {"dateTime": "2025-01-15T09:30:00+08:00"},
  "conferenceData": {
    "createRequest": {
      "requestId": "unique-request-123",
      "conferenceSolutionKey": {"type": "hangoutsMeet"}
    }
  }
}'

# Create event with reminders
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Important Deadline",
  "start": {"dateTime": "2025-01-20T17:00:00+08:00"},
  "end": {"dateTime": "2025-01-20T18:00:00+08:00"},
  "reminders": {
    "useDefault": false,
    "overrides": [
      {"method": "email", "minutes": 1440},
      {"method": "popup", "minutes": 30}
    ]
  }
}'

# Create event with color
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Urgent Review",
  "start": {"dateTime": "2025-01-15T16:00:00+08:00"},
  "end": {"dateTime": "2025-01-15T17:00:00+08:00"},
  "colorId": "11"
}'
```

### Event Color IDs

| ID | Color       |
| -- | ----------- |
| 1  | Lavender    |
| 2  | Sage        |
| 3  | Grape       |
| 4  | Flamingo    |
| 5  | Banana      |
| 6  | Tangerine   |
| 7  | Peacock     |
| 8  | Graphite    |
| 9  | Blueberry   |
| 10 | Basil       |
| 11 | Tomato      |

## Recurring Events

```bash
# Create daily recurring event
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Daily Standup",
  "start": {"dateTime": "2025-01-15T09:00:00+08:00", "timeZone": "Asia/Taipei"},
  "end": {"dateTime": "2025-01-15T09:15:00+08:00", "timeZone": "Asia/Taipei"},
  "recurrence": ["RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR"]
}'

# Create weekly recurring event
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Weekly 1:1",
  "start": {"dateTime": "2025-01-15T14:00:00+08:00", "timeZone": "Asia/Taipei"},
  "end": {"dateTime": "2025-01-15T14:30:00+08:00", "timeZone": "Asia/Taipei"},
  "recurrence": ["RRULE:FREQ=WEEKLY;BYDAY=WE"]
}'

# Create monthly recurring event (ends after 12 occurrences)
gws calendar events insert --params '{"calendarId":"primary"}' --json '{
  "summary": "Monthly Review",
  "start": {"dateTime": "2025-01-15T10:00:00+08:00", "timeZone": "Asia/Taipei"},
  "end": {"dateTime": "2025-01-15T11:00:00+08:00", "timeZone": "Asia/Taipei"},
  "recurrence": ["RRULE:FREQ=MONTHLY;BYMONTHDAY=15;COUNT=12"]
}'
```

## Update Events

```bash
# Update event summary and time
gws calendar events update --params '{"calendarId":"primary","eventId":"EVENT_ID"}' --json '{
  "summary": "Updated Meeting Title",
  "start": {"dateTime": "2025-01-15T11:00:00+08:00"},
  "end": {"dateTime": "2025-01-15T12:00:00+08:00"}
}'

# Partial update (patch)
gws calendar events patch --params '{"calendarId":"primary","eventId":"EVENT_ID"}' --json '{
  "summary": "New Title Only"
}'

# Add attendee to existing event
gws calendar events patch --params '{"calendarId":"primary","eventId":"EVENT_ID","sendUpdates":"all"}' --json '{
  "attendees": [
    {"email": "existing@example.com"},
    {"email": "new-attendee@example.com"}
  ]
}'

# Move event to another calendar
gws calendar events move --params '{"calendarId":"primary","eventId":"EVENT_ID","destination":"other-calendar-id@group.calendar.google.com"}'
```

## Delete Events

```bash
# Delete an event
gws calendar events delete --params '{"calendarId":"primary","eventId":"EVENT_ID"}'

# Delete and notify attendees
gws calendar events delete --params '{"calendarId":"primary","eventId":"EVENT_ID","sendUpdates":"all"}'
```

## Get Event Details

```bash
# Get a specific event
gws calendar events get --params '{"calendarId":"primary","eventId":"EVENT_ID"}'

# Get event instances (for recurring events)
gws calendar events instances --params '{"calendarId":"primary","eventId":"EVENT_ID","maxResults":10}'
```

## Free/Busy Query

```bash
# Check availability for multiple users
gws calendar freebusy query --json '{
  "timeMin": "2025-01-15T08:00:00+08:00",
  "timeMax": "2025-01-15T18:00:00+08:00",
  "items": [
    {"id": "user1@example.com"},
    {"id": "user2@example.com"},
    {"id": "user3@example.com"}
  ]
}'
```

## Calendar Management

```bash
# Create a new calendar
gws calendar calendars insert --json '{"summary":"Project Alpha","timeZone":"Asia/Taipei"}'

# Update calendar properties
gws calendar calendars update --params '{"calendarId":"CALENDAR_ID"}' --json '{"summary":"Renamed Calendar","description":"Updated description"}'

# Delete a calendar
gws calendar calendars delete --params '{"calendarId":"CALENDAR_ID"}'

# Clear all events from a calendar
gws calendar calendars clear --params '{"calendarId":"CALENDAR_ID"}'
```

## Calendar ACL (Access Control)

```bash
# List access rules
gws calendar acl list --params '{"calendarId":"CALENDAR_ID"}'

# Share calendar with a user
gws calendar acl insert --params '{"calendarId":"CALENDAR_ID"}' --json '{"scope":{"type":"user","value":"user@example.com"},"role":"reader"}'

# ACL roles: freeBusyReader, reader, writer, owner

# Remove access
gws calendar acl delete --params '{"calendarId":"CALENDAR_ID","ruleId":"user:user@example.com"}'
```

## Quick Event (Natural Language)

```bash
# Create event with quick text (Google parses naturally)
gws calendar events quickAdd --params '{"calendarId":"primary","text":"Lunch with Alice tomorrow at noon"}'

gws calendar events quickAdd --params '{"calendarId":"primary","text":"Team meeting every Monday at 10am"}'
```
