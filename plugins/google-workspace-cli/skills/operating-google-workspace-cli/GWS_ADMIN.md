# gws Admin Operations

Complete reference for Google Workspace Admin operations via the `gws` CLI. Requires Google Workspace admin privileges.

## Prerequisites

```bash
gws auth login --scopes admin
# Full admin scopes if needed:
# gws auth login --scopes admin.directory.user,admin.directory.group,admin.directory.orgunit,admin.reports.audit,admin.reports.usage
```

## User Management

```bash
# List all users in the domain
gws admin directory users list --params '{"domain":"example.com","maxResults":100}'

# List all users (paginated)
gws admin directory users list --params '{"domain":"example.com","maxResults":500}' --page-all

# Search users by name
gws admin directory users list --params '{"domain":"example.com","query":"name:John"}'

# Search users by email
gws admin directory users list --params '{"domain":"example.com","query":"email:john*"}'

# Search users by org unit
gws admin directory users list --params '{"domain":"example.com","query":"orgUnitPath=/Engineering"}'

# Get a specific user
gws admin directory users get --params '{"userKey":"user@example.com"}'

# Get user with specific fields
gws admin directory users get --params '{"userKey":"user@example.com","projection":"full"}'

# Create a new user
gws admin directory users insert --json '{
  "primaryEmail": "newuser@example.com",
  "name": {"givenName": "New", "familyName": "User"},
  "password": "TempPassword123!",
  "changePasswordAtNextLogin": true,
  "orgUnitPath": "/Engineering"
}'

# Update user
gws admin directory users update --params '{"userKey":"user@example.com"}' --json '{
  "name": {"givenName": "Updated", "familyName": "Name"},
  "phones": [{"value": "+1234567890", "type": "work", "primary": true}]
}'

# Suspend a user
gws admin directory users update --params '{"userKey":"user@example.com"}' --json '{"suspended": true}'

# Unsuspend a user
gws admin directory users update --params '{"userKey":"user@example.com"}' --json '{"suspended": false}'

# Archive a user
gws admin directory users update --params '{"userKey":"user@example.com"}' --json '{"archived": true}'

# Delete a user
gws admin directory users delete --params '{"userKey":"user@example.com"}'

# Make user an admin
gws admin directory users makeAdmin --params '{"userKey":"user@example.com"}' --json '{"status": true}'

# List user aliases
gws admin directory users aliases list --params '{"userKey":"user@example.com"}'

# Add alias
gws admin directory users aliases insert --params '{"userKey":"user@example.com"}' --json '{"alias": "alias@example.com"}'
```

## Group Management

```bash
# List all groups
gws admin directory groups list --params '{"domain":"example.com","maxResults":200}'

# List all groups (paginated)
gws admin directory groups list --params '{"domain":"example.com"}' --page-all

# Search groups
gws admin directory groups list --params '{"domain":"example.com","query":"name:Engineering"}'

# Get a specific group
gws admin directory groups get --params '{"groupKey":"group@example.com"}'

# Create a group
gws admin directory groups insert --json '{
  "email": "new-team@example.com",
  "name": "New Team",
  "description": "New team group"
}'

# Update group
gws admin directory groups update --params '{"groupKey":"group@example.com"}' --json '{
  "name": "Updated Group Name",
  "description": "Updated description"
}'

# Delete a group
gws admin directory groups delete --params '{"groupKey":"group@example.com"}'

# List group members
gws admin directory members list --params '{"groupKey":"group@example.com"}'

# Add member to group
gws admin directory members insert --params '{"groupKey":"group@example.com"}' --json '{
  "email": "user@example.com",
  "role": "MEMBER"
}'

# Add as owner
gws admin directory members insert --params '{"groupKey":"group@example.com"}' --json '{
  "email": "user@example.com",
  "role": "OWNER"
}'

# Add as manager
gws admin directory members insert --params '{"groupKey":"group@example.com"}' --json '{
  "email": "user@example.com",
  "role": "MANAGER"
}'

# Update member role
gws admin directory members update --params '{"groupKey":"group@example.com","memberKey":"user@example.com"}' --json '{
  "role": "OWNER"
}'

# Remove member from group
gws admin directory members delete --params '{"groupKey":"group@example.com","memberKey":"user@example.com"}'

# Check if user is a member
gws admin directory members hasMember --params '{"groupKey":"group@example.com","memberKey":"user@example.com"}'
```

### Group Member Roles

| Role      | Description                                   |
| --------- | --------------------------------------------- |
| `MEMBER`  | Regular member                                |
| `MANAGER` | Can manage members and settings               |
| `OWNER`   | Full control including deletion               |

## Organizational Units

```bash
# List all OUs
gws admin directory orgunits list --params '{"customerId":"my_customer"}'

# Get a specific OU
gws admin directory orgunits get --params '{"customerId":"my_customer","orgUnitPath":"/Engineering"}'

# Create an OU
gws admin directory orgunits insert --params '{"customerId":"my_customer"}' --json '{
  "name": "QA Team",
  "parentOrgUnitPath": "/Engineering",
  "description": "Quality Assurance team"
}'

# Update an OU
gws admin directory orgunits update --params '{"customerId":"my_customer","orgUnitPath":"/Engineering/QA Team"}' --json '{
  "description": "Updated QA team description"
}'

# Move user to an OU
gws admin directory users update --params '{"userKey":"user@example.com"}' --json '{
  "orgUnitPath": "/Engineering/QA Team"
}'

# Delete an OU
gws admin directory orgunits delete --params '{"customerId":"my_customer","orgUnitPath":"/Engineering/QA Team"}'
```

## Admin Roles

```bash
# List admin roles
gws admin directory roles list --params '{"customer":"my_customer"}'

# List role assignments
gws admin directory roleAssignments list --params '{"customer":"my_customer"}'

# Assign a role to a user
gws admin directory roleAssignments insert --params '{"customer":"my_customer"}' --json '{
  "roleId": "ROLE_ID",
  "assignedTo": "USER_ID",
  "scopeType": "CUSTOMER"
}'
```

## Domains

```bash
# List domains
gws admin directory domains list --params '{"customer":"my_customer"}'

# Get a specific domain
gws admin directory domains get --params '{"customer":"my_customer","domainName":"example.com"}'
```

## Admin Reports

```bash
# Get admin activity report
gws admin reports activities list --params '{"userKey":"all","applicationName":"admin","maxResults":50}'

# Get login activity
gws admin reports activities list --params '{"userKey":"all","applicationName":"login","maxResults":50}'

# Get Drive activity
gws admin reports activities list --params '{"userKey":"all","applicationName":"drive","maxResults":50}'

# Get activity for a specific user
gws admin reports activities list --params '{"userKey":"user@example.com","applicationName":"login","maxResults":20}'

# Get activity by date range
gws admin reports activities list --params '{"userKey":"all","applicationName":"admin","startTime":"2025-01-01T00:00:00.000Z","endTime":"2025-01-31T23:59:59.000Z"}'

# Get user usage report
gws admin reports usageReports get --params '{"userKey":"all","date":"2025-01-15"}'

# Get customer usage report
gws admin reports customerUsageReports get --params '{"date":"2025-01-15"}'
```

### Report Application Names

| Application   | Description                         |
| ------------- | ----------------------------------- |
| `admin`       | Admin console activities            |
| `login`       | User login events                   |
| `drive`       | Google Drive activities             |
| `calendar`    | Calendar activities                 |
| `token`       | OAuth token events                  |
| `groups`      | Groups activities                   |
| `mobile`      | Mobile device activities            |
| `saml`        | SAML authentication events          |
| `chat`        | Google Chat activities              |
| `meet`        | Google Meet activities              |

## Chrome Devices (if applicable)

```bash
# List Chrome OS devices
gws admin directory chromeosdevices list --params '{"customerId":"my_customer","maxResults":100}'

# Get a specific device
gws admin directory chromeosdevices get --params '{"customerId":"my_customer","deviceId":"DEVICE_ID"}'

# Update device (add notes, assign user, move OU)
gws admin directory chromeosdevices update --params '{"customerId":"my_customer","deviceId":"DEVICE_ID"}' --json '{
  "annotatedUser": "user@example.com",
  "annotatedLocation": "Building A, Floor 3",
  "notes": "Assigned to engineering team",
  "orgUnitPath": "/Devices/Engineering"
}'

# Disable a device
gws admin directory chromeosdevices action --params '{"customerId":"my_customer","resourceId":"DEVICE_ID"}' --json '{"action": "disable"}'
```

## Mobile Devices

```bash
# List mobile devices
gws admin directory mobiledevices list --params '{"customerId":"my_customer"}'

# Get device details
gws admin directory mobiledevices get --params '{"customerId":"my_customer","resourceId":"DEVICE_ID"}'

# Wipe a device
gws admin directory mobiledevices action --params '{"customerId":"my_customer","resourceId":"DEVICE_ID"}' --json '{"action": "admin_remote_wipe"}'

# Block a device
gws admin directory mobiledevices action --params '{"customerId":"my_customer","resourceId":"DEVICE_ID"}' --json '{"action": "block"}'
```

## Security & Tokens

```bash
# List OAuth tokens for a user
gws admin directory tokens list --params '{"userKey":"user@example.com"}'

# Revoke a token
gws admin directory tokens delete --params '{"userKey":"user@example.com","clientId":"CLIENT_ID"}'

# List 2-step verification enrollment
gws admin reports activities list --params '{"userKey":"all","applicationName":"login","filters":"is_2sv_enrolled==true"}'
```
