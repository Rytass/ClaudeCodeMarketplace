# gws Meet, Tasks, Forms, Keep & Slides Operations

Reference for Google Meet, Tasks, Forms, Keep, and Slides operations via the `gws` CLI.

---

## Google Meet

### Prerequisites

```bash
gws auth login --scopes https://www.googleapis.com/auth/meetings.space.created
```

### Conference Records

```bash
# List recent conference records (past meetings)
gws meet conferenceRecords list --params '{"pageSize":10}'

# Get a specific conference record
gws meet conferenceRecords get --params '{"name":"conferenceRecords/RECORD_ID"}'

# List participants of a meeting
gws meet conferenceRecords participants list --params '{"parent":"conferenceRecords/RECORD_ID"}'

# Get participant sessions
gws meet conferenceRecords participants participantSessions list \
  --params '{"parent":"conferenceRecords/RECORD_ID/participants/PARTICIPANT_ID"}'
```

### Meeting Spaces

```bash
# Create a meeting space
gws meet spaces create --json '{}'

# Create a meeting space with specific config
gws meet spaces create --json '{
  "config": {
    "accessType": "OPEN",
    "entryPointAccess": "ALL"
  }
}'

# Get a meeting space
gws meet spaces get --params '{"name":"spaces/SPACE_ID"}'

# Update meeting space config
gws meet spaces patch --params '{"name":"spaces/SPACE_ID","updateMask":"config"}' --json '{
  "config": {"accessType": "TRUSTED"}
}'

# End an active meeting
gws meet spaces endActiveConference --params '{"name":"spaces/SPACE_ID"}'
```

### Meeting Access Types

| Type        | Description                                    |
| ----------- | ---------------------------------------------- |
| `OPEN`      | Anyone with the link can join                  |
| `TRUSTED`   | Only organization members can join directly    |
| `RESTRICTED`| Only invited attendees can join                |

### Recordings & Transcripts

```bash
# List recordings for a conference
gws meet conferenceRecords recordings list --params '{"parent":"conferenceRecords/RECORD_ID"}'

# Get a specific recording
gws meet conferenceRecords recordings get --params '{"name":"conferenceRecords/RECORD_ID/recordings/RECORDING_ID"}'

# List transcripts
gws meet conferenceRecords transcripts list --params '{"parent":"conferenceRecords/RECORD_ID"}'

# Get transcript entries
gws meet conferenceRecords transcripts entries list \
  --params '{"parent":"conferenceRecords/RECORD_ID/transcripts/TRANSCRIPT_ID"}'
```

---

## Google Tasks

### Prerequisites

```bash
gws auth login --scopes tasks
```

### Task Lists

```bash
# List all task lists
gws tasks tasklists list

# Get a specific task list
gws tasks tasklists get --params '{"tasklist":"TASKLIST_ID"}'

# Create a task list
gws tasks tasklists insert --json '{"title":"Work Tasks"}'

# Update a task list
gws tasks tasklists update --params '{"tasklist":"TASKLIST_ID"}' --json '{"title":"Updated Task List"}'

# Delete a task list
gws tasks tasklists delete --params '{"tasklist":"TASKLIST_ID"}'
```

### Tasks

```bash
# List tasks in a task list
gws tasks tasks list --params '{"tasklist":"TASKLIST_ID"}'

# List only completed tasks
gws tasks tasks list --params '{"tasklist":"TASKLIST_ID","showCompleted":true,"showHidden":true}'

# Get a specific task
gws tasks tasks get --params '{"tasklist":"TASKLIST_ID","task":"TASK_ID"}'

# Create a task
gws tasks tasks insert --params '{"tasklist":"TASKLIST_ID"}' --json '{
  "title": "Review PR #42",
  "notes": "Check for security vulnerabilities",
  "due": "2025-01-20T00:00:00.000Z"
}'

# Create a subtask (by specifying parent)
gws tasks tasks insert --params '{"tasklist":"TASKLIST_ID","parent":"PARENT_TASK_ID"}' --json '{
  "title": "Subtask item"
}'

# Update a task
gws tasks tasks update --params '{"tasklist":"TASKLIST_ID","task":"TASK_ID"}' --json '{
  "title": "Updated task title",
  "notes": "Updated notes",
  "due": "2025-01-25T00:00:00.000Z"
}'

# Complete a task
gws tasks tasks update --params '{"tasklist":"TASKLIST_ID","task":"TASK_ID"}' --json '{
  "status": "completed"
}'

# Uncomplete a task
gws tasks tasks update --params '{"tasklist":"TASKLIST_ID","task":"TASK_ID"}' --json '{
  "status": "needsAction"
}'

# Move a task (reorder)
gws tasks tasks move --params '{"tasklist":"TASKLIST_ID","task":"TASK_ID","previous":"PREV_TASK_ID"}'

# Delete a task
gws tasks tasks delete --params '{"tasklist":"TASKLIST_ID","task":"TASK_ID"}'

# Clear completed tasks from a list
gws tasks tasks clear --params '{"tasklist":"TASKLIST_ID"}'
```

---

## Google Forms

### Prerequisites

```bash
gws auth login --scopes forms
```

### Forms

```bash
# Get a form
gws forms forms get --params '{"formId":"FORM_ID"}'

# Create a form
gws forms forms create --json '{"info":{"title":"Customer Feedback","documentTitle":"feedback-form"}}'

# Update form info
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "updateFormInfo": {
      "info": {"title": "Updated Title", "description": "Please fill out this survey."},
      "updateMask": "title,description"
    }
  }]
}'

# Add a short answer question
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "createItem": {
      "item": {
        "title": "What is your name?",
        "questionItem": {
          "question": {
            "required": true,
            "textQuestion": {"paragraph": false}
          }
        }
      },
      "location": {"index": 0}
    }
  }]
}'

# Add a paragraph question
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "createItem": {
      "item": {
        "title": "Describe your experience",
        "questionItem": {
          "question": {
            "required": false,
            "textQuestion": {"paragraph": true}
          }
        }
      },
      "location": {"index": 1}
    }
  }]
}'

# Add a multiple choice question
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "createItem": {
      "item": {
        "title": "How satisfied are you?",
        "questionItem": {
          "question": {
            "required": true,
            "choiceQuestion": {
              "type": "RADIO",
              "options": [
                {"value": "Very Satisfied"},
                {"value": "Satisfied"},
                {"value": "Neutral"},
                {"value": "Dissatisfied"},
                {"value": "Very Dissatisfied"}
              ]
            }
          }
        }
      },
      "location": {"index": 2}
    }
  }]
}'

# Add a checkbox question
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "createItem": {
      "item": {
        "title": "Select all that apply",
        "questionItem": {
          "question": {
            "choiceQuestion": {
              "type": "CHECKBOX",
              "options": [
                {"value": "Option A"},
                {"value": "Option B"},
                {"value": "Option C"}
              ]
            }
          }
        }
      },
      "location": {"index": 3}
    }
  }]
}'

# Add a dropdown question
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "createItem": {
      "item": {
        "title": "Select your department",
        "questionItem": {
          "question": {
            "choiceQuestion": {
              "type": "DROP_DOWN",
              "options": [
                {"value": "Engineering"},
                {"value": "Marketing"},
                {"value": "Sales"},
                {"value": "HR"}
              ]
            }
          }
        }
      },
      "location": {"index": 4}
    }
  }]
}'

# Add a scale (linear) question
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{
    "createItem": {
      "item": {
        "title": "Rate from 1 to 10",
        "questionItem": {
          "question": {
            "scaleQuestion": {
              "low": 1,
              "high": 10,
              "lowLabel": "Poor",
              "highLabel": "Excellent"
            }
          }
        }
      },
      "location": {"index": 5}
    }
  }]
}'

# Delete an item
gws forms forms batchUpdate --params '{"formId":"FORM_ID"}' --json '{
  "requests": [{"deleteItem": {"location": {"index": 2}}}]
}'
```

### Form Responses

```bash
# List form responses
gws forms forms responses list --params '{"formId":"FORM_ID"}'

# Get a specific response
gws forms forms responses get --params '{"formId":"FORM_ID","responseId":"RESPONSE_ID"}'
```

### Form Watches

```bash
# Create a watch (get notified on new responses)
gws forms forms watches create --params '{"formId":"FORM_ID"}' --json '{
  "watch": {
    "target": {"topic": {"topicName": "projects/PROJECT_ID/topics/TOPIC_NAME"}},
    "eventType": "RESPONSES"
  }
}'

# List watches
gws forms forms watches list --params '{"formId":"FORM_ID"}'

# Delete a watch
gws forms forms watches delete --params '{"formId":"FORM_ID","watchId":"WATCH_ID"}'
```

---

## Google Keep

### Prerequisites

```bash
gws auth login --scopes https://www.googleapis.com/auth/keep
```

**Note**: Keep API has limited availability. It requires Google Workspace Enterprise or Education Plus.

### Notes

```bash
# List notes
gws keep notes list --params '{"pageSize":25}'

# Get a specific note
gws keep notes get --params '{"name":"notes/NOTE_ID"}'

# Create a text note
gws keep notes create --json '{
  "title": "Meeting Notes",
  "body": {"text": {"text": "Discuss Q1 goals and roadmap priorities."}}
}'

# Create a list note
gws keep notes create --json '{
  "title": "Shopping List",
  "body": {
    "list": {
      "listItems": [
        {"text": {"text": "Milk"}, "checked": false},
        {"text": {"text": "Eggs"}, "checked": false},
        {"text": {"text": "Bread"}, "checked": true}
      ]
    }
  }
}'

# Delete a note
gws keep notes delete --params '{"name":"notes/NOTE_ID"}'
```

---

## Google Slides

### Prerequisites

```bash
gws auth login --scopes https://www.googleapis.com/auth/presentations
```

### Presentations

```bash
# Create a presentation
gws slides presentations create --json '{"title":"Quarterly Review"}'

# Get a presentation
gws slides presentations get --params '{"presentationId":"PRESENTATION_ID"}'

# Get slide page IDs
gws slides presentations get --params '{"presentationId":"PRESENTATION_ID"}' \
  | jq '[.slides[].objectId]'

# Get a specific page
gws slides presentations pages get --params '{"presentationId":"PRESENTATION_ID","pageObjectId":"PAGE_ID"}'
```

### Modify Presentations

```bash
# Add a new blank slide
gws slides presentations batchUpdate --params '{"presentationId":"PRESENTATION_ID"}' --json '{
  "requests": [{
    "createSlide": {
      "insertionIndex": 1,
      "slideLayoutReference": {"predefinedLayout": "TITLE_AND_BODY"}
    }
  }]
}'

# Insert text into a placeholder
gws slides presentations batchUpdate --params '{"presentationId":"PRESENTATION_ID"}' --json '{
  "requests": [{
    "insertText": {
      "objectId": "PLACEHOLDER_ID",
      "text": "Slide Title Here",
      "insertionIndex": 0
    }
  }]
}'

# Replace all text (template variables)
gws slides presentations batchUpdate --params '{"presentationId":"PRESENTATION_ID"}' --json '{
  "requests": [{
    "replaceAllText": {
      "containsText": {"text": "{{COMPANY_NAME}}", "matchCase": true},
      "replaceText": "Acme Corp"
    }
  }]
}'

# Delete a slide
gws slides presentations batchUpdate --params '{"presentationId":"PRESENTATION_ID"}' --json '{
  "requests": [{"deleteObject": {"objectId": "SLIDE_OBJECT_ID"}}]
}'

# Add an image to a slide
gws slides presentations batchUpdate --params '{"presentationId":"PRESENTATION_ID"}' --json '{
  "requests": [{
    "createImage": {
      "url": "https://example.com/chart.png",
      "elementProperties": {
        "pageObjectId": "SLIDE_OBJECT_ID",
        "size": {"width": {"magnitude": 300, "unit": "PT"}, "height": {"magnitude": 200, "unit": "PT"}},
        "transform": {"scaleX": 1, "scaleY": 1, "translateX": 100, "translateY": 100, "unit": "PT"}
      }
    }
  }]
}'
```

### Predefined Slide Layouts

| Layout                  | Description                          |
| ----------------------- | ------------------------------------ |
| `BLANK`                 | Empty slide                          |
| `CAPTION_ONLY`          | Caption at bottom                    |
| `TITLE`                 | Title slide                          |
| `TITLE_AND_BODY`        | Title with body text                 |
| `TITLE_AND_TWO_COLUMNS` | Title with two body columns          |
| `TITLE_ONLY`            | Title bar only                       |
| `ONE_COLUMN_TEXT`       | Single column text                   |
| `MAIN_POINT`            | Large centered text                  |
| `SECTION_HEADER`        | Section divider                      |
| `SECTION_TITLE_AND_DESCRIPTION` | Section with description     |
| `BIG_NUMBER`            | Large number display                 |
