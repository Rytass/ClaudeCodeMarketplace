# GAM — Google Workspace Admin Bulk Operations

GAM (GAMADV-XTD3) is the recommended tool for bulk Google Workspace admin operations. Use GAM when you need CSV-based batch processing, bulk user provisioning, or domain-wide device management.

## When to Use GAM vs gws

| Scenario                               | Use GAM | Use gws |
| -------------------------------------- | ------- | ------- |
| Bulk create 100+ users from CSV        | Yes     |         |
| Manage a single user                   |         | Yes     |
| Bulk update group memberships          | Yes     |         |
| Export user list to CSV                 | Yes     |         |
| Chrome device fleet management         | Yes     |         |
| Interactive API exploration            |         | Yes     |
| One-off admin operations               |         | Yes     |
| Domain-wide delegation operations      | Yes     |         |

## Installation

```bash
# Linux / macOS — automated installer
bash <(curl -s -S -L https://git.io/install-gam)

# Installs to ~/bin/gam/
# Add to PATH:
export PATH="$HOME/bin/gam:$PATH"
# Add the above line to ~/.bashrc or ~/.zshrc

# Verify installation
gam version
```

## Initial Setup

```bash
# Full interactive setup
gam setup

# This will:
# 1. Create or select a GCP project
# 2. Enable Admin SDK and other required APIs
# 3. Create a service account
# 4. Generate domain-wide delegation instructions
# 5. Create OAuth credentials for admin operations
```

### Domain-Wide Delegation

After `gam setup`, you must authorize the service account in the Google Admin Console:

1. Go to **Admin Console → Security → API controls → Domain-wide delegation**
2. Click **Add new**
3. Enter the **Client ID** from the GAM setup output
4. Enter the required **OAuth scopes** (GAM lists them during setup)
5. Click **Authorize**

Verify setup:

```bash
gam info domain
gam print users maxresults 5
```

## User Management

```bash
# List all users
gam print users

# List users with specific fields
gam print users fields primaryEmail,name,suspended,orgUnitPath

# List users in an OU
gam print users query "orgUnitPath='/Engineering'"

# Export users to CSV
gam print users > users.csv
gam print users fields primaryEmail,name,orgUnitPath,suspended,lastLoginTime > users_report.csv

# Get a specific user
gam info user user@example.com

# Create a user
gam create user newuser@example.com firstname "First" lastname "Last" password "TempPass123!" changepassword on org "/Engineering"

# Bulk create users from CSV
# CSV format: primaryEmail,firstName,lastName,password,orgUnitPath
gam csv users.csv gam create user ~primaryEmail firstname ~firstName lastname ~lastName password ~password org ~orgUnitPath changepassword on

# Update a user
gam update user user@example.com firstname "NewFirst" lastname "NewLast" phone type work value "+1234567890"

# Suspend a user
gam update user user@example.com suspended on

# Unsuspend a user
gam update user user@example.com suspended off

# Delete a user
gam delete user user@example.com

# Bulk suspend users from CSV
gam csv suspend_list.csv gam update user ~primaryEmail suspended on

# Reset password
gam update user user@example.com password "NewPass123!" changepassword on

# Move user to another OU
gam update user user@example.com org "/Marketing"

# Bulk move users
gam csv move_users.csv gam update user ~primaryEmail org ~newOrgUnitPath

# Add email alias
gam create alias alias@example.com user user@example.com

# Remove email alias
gam delete alias alias@example.com
```

## Group Management

```bash
# List all groups
gam print groups

# List groups with members
gam print groups members

# Get group info
gam info group team@example.com

# Create a group
gam create group new-team@example.com name "New Team" description "Team description"

# Delete a group
gam delete group old-team@example.com

# List group members
gam print group-members group team@example.com

# Add member to group
gam update group team@example.com add member user@example.com

# Add multiple members
gam update group team@example.com add member user1@example.com user2@example.com user3@example.com

# Bulk add members from CSV
gam csv members.csv gam update group ~groupEmail add member ~memberEmail

# Remove member from group
gam update group team@example.com remove member user@example.com

# Change member role
gam update group team@example.com update owner user@example.com
gam update group team@example.com update manager user@example.com
gam update group team@example.com update member user@example.com

# Sync group members from CSV (add missing, remove extra)
gam update group team@example.com sync member file members.csv

# Export all groups and their members
gam print group-members > all_group_members.csv
```

## Drive Management

```bash
# Show user's Drive usage
gam user user@example.com show driveusage

# List files owned by a user
gam user user@example.com show filelist fields id,name,mimeType

# Transfer Drive ownership (all files)
gam user departing@example.com transfer drive newowner@example.com

# Transfer specific folder
gam user user@example.com transfer drive newowner@example.com select "FOLDER_ID"

# Delete all Drive files for a user
gam user user@example.com delete drivefile allfiles

# Show shared drives
gam print shareddrives

# Create a shared drive
gam create shareddrive "Project Alpha"

# Add member to shared drive
gam add drivefileacl "SHARED_DRIVE_ID" user user@example.com role organizer
```

## Chrome Device Management

```bash
# List Chrome OS devices
gam print cros

# List with specific fields
gam print cros fields deviceId,serialNumber,status,orgUnitPath,lastSync,annotatedUser

# Export to CSV
gam print cros > chrome_devices.csv

# Get device info
gam info cros "DEVICE_ID"

# Move device to OU
gam update cros "DEVICE_ID" ou "/Devices/Engineering"

# Bulk move devices from CSV
gam csv devices.csv gam update cros ~deviceId ou ~newOU

# Disable a device
gam update cros "DEVICE_ID" action disable

# Re-enable a device
gam update cros "DEVICE_ID" action reenable

# Deprovision a device
gam update cros "DEVICE_ID" action deprovision acknowledge_device_touch_requirement

# Annotate a device
gam update cros "DEVICE_ID" user "user@example.com" location "Building A" notes "Assigned for Q1"

# Bulk update device assignments from CSV
gam csv device_assignments.csv gam update cros ~deviceId user ~assignedUser location ~location
```

## Calendar Management

```bash
# Show user's calendar list
gam user user@example.com show calendars

# Add calendar to user
gam user user@example.com add calendar "team-calendar@group.calendar.google.com"

# Delete events in date range
gam user user@example.com delete events start "2025-01-01" end "2025-01-31"
```

## Email Management

```bash
# Show user's email delegates
gam user user@example.com show delegates

# Add email delegate
gam user user@example.com add delegate assistant@example.com

# Set vacation message
gam user user@example.com vacation on subject "Out of Office" message "I am currently unavailable." startdate "2025-01-20" enddate "2025-01-27"

# Turn off vacation message
gam user user@example.com vacation off

# Set email forwarding
gam user user@example.com forward on forward-to@example.com keep
```

## Organizational Units

```bash
# List all OUs
gam print orgs

# Create an OU
gam create org "QA Team" parent "/Engineering" description "Quality Assurance"

# Move OU
gam update org "/Engineering/QA Team" parent "/Product"

# Delete an OU
gam delete org "/Engineering/Old Team"
```

## Reporting

```bash
# User login activity
gam report login user all start "2025-01-01" end "2025-01-31" > login_report.csv

# Admin activity
gam report admin start "2025-01-01" end "2025-01-31" > admin_report.csv

# Drive activity
gam report drive user all start "2025-01-01" > drive_report.csv

# User accounts report
gam report users > user_accounts_report.csv

# Customer usage report
gam report customer > customer_usage.csv
```

## Batch Operations Pattern

```bash
# General CSV batch pattern:
# 1. Create a CSV file with required columns
# 2. Use gam csv to process each row

# Example CSV (new_users.csv):
# primaryEmail,firstName,lastName,password,orgUnitPath
# alice@example.com,Alice,Smith,TempPass1!,/Engineering
# bob@example.com,Bob,Jones,TempPass2!,/Marketing

# Process:
gam csv new_users.csv gam create user ~primaryEmail firstname ~firstName lastname ~lastName password ~password org ~orgUnitPath changepassword on

# Parallel processing (faster):
gam csv new_users.csv multiprocess gam create user ~primaryEmail firstname ~firstName lastname ~lastName password ~password org ~orgUnitPath changepassword on
```

## Common GAM Environment Variables

```bash
# GAM configuration directory
export GAMCFGDIR="$HOME/.gam"

# Number of parallel threads for batch operations
export GAM_THREADS=5
```
