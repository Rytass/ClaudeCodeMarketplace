# Skill Creation Checklist

Use this checklist when creating or updating Claude Code skills.

## Before Creating

### Validate the Need

- [ ] **Repeated task**: Have I done this task at least 5 times?
- [ ] **Future need**: Will I do it at least 10 more times?
- [ ] **Clear scope**: Can I describe the skill's purpose in one sentence?
- [ ] **Not duplicate**: Does a similar skill already exist?

### Define the Scope

- [ ] **Single responsibility**: One skill = one clear purpose
- [ ] **Measurable outcome**: What does success look like?
- [ ] **Boundaries**: What should this skill NOT do?

## During Creation

### File Structure

- [ ] Directory name matches `name` field exactly
- [ ] `SKILL.md` exists in skill directory
- [ ] Supporting files (if any) are one level deep
- [ ] File paths use forward slashes

### Frontmatter

- [ ] Starts with `---` on line 1 (no blank lines)
- [ ] `name` is lowercase with hyphens only
- [ ] `name` uses gerund form (verb-ing)
- [ ] `description` is under 1024 characters
- [ ] `description` includes action verbs
- [ ] `description` includes domain keywords
- [ ] `description` includes trigger phrases
- [ ] Ends with `---` before content

### Content Quality

- [ ] Main `SKILL.md` is under 500 lines
- [ ] Instructions are clear and actionable
- [ ] Examples demonstrate expected behavior
- [ ] Tables used for quick reference
- [ ] Links to supporting files where needed

### Optional Fields

- [ ] `allowed-tools` set if restricting access needed
- [ ] `model` set if specific model required

## After Creation

### Testing

- [ ] Restarted Claude Code to load skill
- [ ] Verified skill appears in "What skills are available?"
- [ ] Tested with natural trigger phrases
- [ ] Confirmed correct skill activates (not a similar one)
- [ ] Validated instructions produce expected results

### Documentation

- [ ] Skill purpose is clear from `SKILL.md` alone
- [ ] Dependencies documented (if any)
- [ ] Version noted in project CLAUDE.md (if applicable)

### Sharing (if project skill)

- [ ] Committed to `.claude/skills/` in repo
- [ ] Pushed to remote
- [ ] Team members notified to pull and restart
- [ ] Verified team can trigger the skill

## Maintenance

### Regular Review

- [ ] Skill still needed? (usage frequency)
- [ ] Description still accurate?
- [ ] Instructions still current?
- [ ] No conflicts with other skills?

### Updating

- [ ] Edit `SKILL.md` directly
- [ ] Update version in CLAUDE.md
- [ ] Restart Claude Code
- [ ] Re-test trigger phrases
- [ ] Notify team (if project skill)

### Deprecation

- [ ] Announce deprecation to team
- [ ] Remove skill directory
- [ ] Update CLAUDE.md
- [ ] Commit and push (if project skill)

## Quick Reference

### Trigger Testing Phrases

Try these patterns to test your skill triggers:

```
"Help me [action] [domain]"
"I need to [action]"
"Can you [action] this [object]?"
"Working with [domain], I need..."
```

### Common Issues

| Issue                    | Solution                              |
|--------------------------|---------------------------------------|
| Skill doesn't trigger    | Add more specific keywords to description |
| Wrong skill activates    | Make descriptions more distinct       |
| Skill not found          | Check directory/name match, restart   |
| Frontmatter error        | Check for tabs, missing `---`         |
| Content too long         | Use progressive disclosure            |
