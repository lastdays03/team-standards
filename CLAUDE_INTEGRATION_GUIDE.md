# Claude Integration Guide

**FOR CLAUDE CODE:** When a user asks you to integrate components from this showcase repository into their project, follow these instructions carefully.

---

## Overview

This repository is a **reference library** of Claude Code infrastructure components. Users will ask you to help integrate specific pieces into their projects. Your role is to:

1. **Ask clarifying questions** about their project structure
2. **Copy the appropriate files**
3. **Customize configurations** for their setup
4. **Verify the integration** works correctly

**Key Principle:** ALWAYS ask before assuming project structure. What works for one project won't work for another.

---

## Tech Stack Compatibility Check

**CRITICAL:** Before integrating a skill, verify the user's tech stack matches the skill requirements.

### Frontend Skills

**nextjs-frontend-guidelines requires:**
- Next.js 15 (App Router)
- React 19
- TypeScript
- Tailwind CSS 4, shadcn/ui

**Before integrating, ask:**
"Do you use Next.js with App Router and Tailwind CSS?"

**If NO:**
```
The nextjs-frontend-guidelines skill is designed specifically for Next.js 15 + Tailwind CSS 4 + shadcn/ui. I can:
1. Help you create a similar skill adapted for [their stack] using this as a template
2. Extract the framework-agnostic patterns (file organization, performance, etc.)
3. Skip this skill if not relevant

Which would you prefer?
```

### Backend Skills

**fastapi-backend-guidelines requires:**
- Python 3.12+
- FastAPI
- SQLModel / SQLAlchemy (async)
- Domain-Driven Design structure

**Before integrating, ask:**
"Do you use Python with FastAPI and SQLModel/SQLAlchemy?"

**If NO:**
```
The fastapi-backend-guidelines skill is designed for FastAPI/SQLModel with DDD. I can:
1. Help you create similar guidelines adapted for [their stack] using this as a template
2. Extract the architecture patterns (DDD/layered architecture works for any framework)
3. Skip this skill

Which would you prefer?
```

### Skills That Are Tech-Agnostic

These work for ANY tech stack:
- **error-tracking** - Sentry works with most stacks
- **pytest-backend-testing** - Python testing patterns (requires pytest)
- **mermaid** - Diagram generation, no tech requirements
- **pdf** / **docx** / **pptx** - Document generation, no tech requirements

---

## General Integration Pattern

When user says: **"Add [component] to my project"**

1. Identify component type (skill/hook/agent/command)
2. **CHECK TECH STACK COMPATIBILITY** (for frontend/backend skills)
3. Ask about their project structure
4. Copy files OR adapt for their stack
5. Customize for their setup
6. Verify integration
7. Provide next steps

---

## Integrating Skills

### Step-by-Step Process

**When user requests a skill** (e.g., "add fastapi-backend-guidelines"):

#### 1. Understand Their Project

**ASK THESE QUESTIONS:**
- "What's your project structure? Single app, monorepo, or multi-service?"
- "Where is your [backend/frontend] code located?"
- "What frameworks/technologies do you use?"

#### 2. Copy the Skill

```bash
cp -r /path/to/showcase/.claude/skills/[skill-name] \
      $CLAUDE_PROJECT_DIR/.claude/skills/
```

#### 3. Verify the Skill Description

Skills activate via Claude Code's **native description matching**. Each skill directory contains a description that Claude uses to determine relevance. No additional configuration files are needed.

**Check the skill's description is appropriate:**
- Read the skill's main file to verify its description matches the user's use case
- If the description needs tweaking for their context, update it

#### 4. Verify Integration

```bash
# Check skill was copied
ls -la $CLAUDE_PROJECT_DIR/.claude/skills/[skill-name]
```

**Tell user:** "The skill will activate automatically when Claude detects relevant context in your prompts or files."

---

### Skill-Specific Notes

#### fastapi-backend-guidelines
- **Tech Requirements:** Python 3.12+, FastAPI, SQLModel/SQLAlchemy (async)
- **Ask:** "Do you use FastAPI with SQLModel?" "Where's your backend code?"
- **If different stack:** Offer to adapt using this as template
- **Adaptation tip:** DDD patterns (domain/service/repository) transfer to most frameworks

#### nextjs-frontend-guidelines
- **Tech Requirements:** Next.js 15 (App Router), React 19, Tailwind CSS 4, shadcn/ui
- **Ask:** "Do you use Next.js with App Router?" "Where's your frontend code?"
- **If different stack:** Offer to create adapted version (Vue, Angular, etc.)
- **Adaptation tip:** File organization and performance patterns transfer, component code doesn't

#### error-tracking
- **Tech Requirements:** Sentry (works with most backends)
- **Ask:** "Do you use Sentry?" "Where's your backend code?"
- **If NO Sentry:** "Want to use this as template for [their error tracking]?"
- **Adaptation tip:** Error tracking philosophy transfers to other tools (Rollbar, Bugsnag, etc.)

#### pytest-backend-testing
- **Tech Requirements:** Python, pytest, FastAPI (for async patterns)
- **Ask:** "Do you use pytest for testing?"
- **Adaptation tip:** Testing strategies and patterns transfer to other Python test frameworks

---

## Adapting Skills for Different Tech Stacks

When user's tech stack differs from skill requirements, you have options:

### Option 1: Adapt Existing Skill (Recommended)

**When to use:** User wants similar guidelines but for different tech

**Process:**
1. **Copy the skill as a starting point:**
   ```bash
   cp -r showcase/.claude/skills/nextjs-frontend-guidelines \
         $CLAUDE_PROJECT_DIR/.claude/skills/vue-dev-guidelines
   ```

2. **Identify what needs changing:**
   - Framework-specific code examples (React → Vue)
   - Library APIs (shadcn/ui → Vuetify/PrimeVue)
   - Import statements
   - Component patterns

3. **Keep what transfers:**
   - File organization principles
   - Performance optimization strategies
   - TypeScript standards
   - General best practices

4. **Replace examples systematically:**
   - Ask user for equivalent patterns in their stack
   - Update code examples to their framework
   - Keep the overall structure and sections

5. **Update skill name and description:**
   - Rename skill appropriately
   - Update the skill description to reflect the new stack
   - Test activation

**Example - Adapting nextjs-frontend-guidelines for Vue:**
```
I'll create vue-dev-guidelines based on the Next.js skill structure:
- Replace React Server Components → Vue components
- Replace shadcn/ui components → [their component library]
- Replace App Router patterns → Vue Router
- Keep: File organization, performance patterns, TypeScript guidelines

This will take a few minutes. Sound good?
```

### Option 2: Extract Framework-Agnostic Patterns

**When to use:** Stacks are very different, but core principles apply

**Process:**
1. Read through the existing skill
2. Identify framework-agnostic patterns:
   - Layered architecture (backend)
   - File organization strategies
   - Performance optimization principles
   - Testing strategies
   - Error handling philosophy

3. Create new skill with just those patterns
4. User can add framework-specific examples later

**Example:**
```
The fastapi-backend-guidelines uses FastAPI/SQLModel, but the DDD architecture
(domain/service/repository) works for Django too.

I can create a skill with:
- Domain-Driven Design pattern
- Separation of concerns principles
- Error handling best practices
- Testing strategies

Then you can add Django-specific examples as you establish patterns.
```

### Option 3: Use as Reference Only

**When to use:** Too different to adapt, but user wants inspiration

**Process:**
1. User browses the existing skill
2. You help create a new skill from scratch
3. Use existing skill's structure as a template
4. Follow modular pattern (main + resource files)

### What Usually Transfers Across Tech Stacks

**Architecture & Organization:**
- Layered architecture (Routes/Controllers/Services pattern)
- Separation of concerns
- File organization strategies (features/ pattern)
- Progressive disclosure (main + resource files)
- Repository pattern for data access

**Development Practices:**
- Error handling philosophy
- Input validation importance
- Testing strategies
- Performance optimization principles
- TypeScript best practices

**Framework-Specific Code:**
- React hooks → Don't transfer to Vue/Angular
- shadcn/ui components → Different component libraries
- SQLModel queries → Different ORM syntax
- FastAPI middleware → Different framework patterns
- Routing implementations → Framework-specific

### When to Recommend Adaptation vs Skipping

**Recommend adaptation if:**
- User wants similar guidelines for their stack
- Core patterns apply (layered architecture, etc.)
- User has time to help with framework-specific examples

**Recommend skipping if:**
- Stacks are completely different
- User doesn't need those patterns
- Would take too long to adapt
- User prefers creating from scratch

---

## Integrating Hooks

### Essential Hook

#### post-tool-use-tracker (PostToolUse)

**Purpose:** Tracks file changes for context management

**Integration (NO customization needed):**

```bash
# Copy file
cp showcase/.claude/hooks/post-tool-use-tracker.sh \
   $CLAUDE_PROJECT_DIR/.claude/hooks/

# Make executable
chmod +x $CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use-tracker.sh
```

**Add to settings.json:**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use-tracker.sh"
          }
        ]
      }
    ]
  }
}
```

**This hook is FULLY GENERIC** - auto-detects project structure!

---

### Optional Hook

#### tsc-check.sh (Stop)

**Purpose:** Runs TypeScript compilation check when Claude stops, catching type errors before they accumulate.

**Before integrating, ask:**
1. "Do you have TypeScript in your project?"
2. "What's your project structure? (monorepo or single app)"
3. "Where are your tsconfig.json files located?"

**For SIMPLE projects (single TypeScript app):**
- The hook auto-detects common directory structures (frontend, backend, src, packages/*, etc.)
- It finds the appropriate tsconfig variant (tsconfig.app.json, tsconfig.build.json, tsconfig.json)
- Copy as-is; no customization needed for standard layouts

**For COMPLEX projects (non-standard structure):**
- Review the `get_repo_for_file()` function to ensure it recognizes the project's directory layout
- The hook already handles common patterns: frontend, client, web, backend, server, api, src, packages/*
- Add custom directory names to the `case` statement if needed

**Integration:**

```bash
# Copy file
cp showcase/.claude/hooks/tsc-check.sh \
   $CLAUDE_PROJECT_DIR/.claude/hooks/

# Make executable
chmod +x $CLAUDE_PROJECT_DIR/.claude/hooks/tsc-check.sh

# Test manually before adding to settings.json
./.claude/hooks/tsc-check.sh
```

**Add to settings.json:**
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/tsc-check.sh"
          }
        ]
      }
    ]
  }
}
```

**IMPORTANT:** If this hook fails, it will block Stop events. Only add if you're sure it works for their setup.

---

## Integrating Agents

**Agents are STANDALONE** - easiest to integrate!

### Standard Agent Integration

```bash
# Copy the agent file
cp showcase/.claude/agents/[agent-name].md \
   $CLAUDE_PROJECT_DIR/.claude/agents/
```

**That's it!** Agents work immediately, no configuration needed.

### Check for Hardcoded Paths

Some agents may reference paths. **Before copying, read the agent file and check for:**

- `~/git/old-project/` → Should be `$CLAUDE_PROJECT_DIR` or `.`
- `/root/git/project/` → Should be `$CLAUDE_PROJECT_DIR` or `.`
- Hardcoded screenshot paths → Ask user where they want screenshots

**If found, update them:**
```bash
sed -i 's|~/git/old-project/|.|g' $CLAUDE_PROJECT_DIR/.claude/agents/[agent].md
sed -i 's|/root/git/.*PROJECT.*DIR|$CLAUDE_PROJECT_DIR|g' \
    $CLAUDE_PROJECT_DIR/.claude/agents/[agent].md
```

### Agent-Specific Notes

**frontend-error-fixer:**
- May reference screenshot paths
- Ask: "Where should screenshots be saved?"

**All other agents:**
- Copy as-is, they're fully generic

---

## Integrating Slash Commands

```bash
# Copy command file
cp showcase/.claude/commands/[command].md \
   $CLAUDE_PROJECT_DIR/.claude/commands/
```

### Customize Paths

Commands may reference dev docs paths. **Check and update:**

**dev-docs and dev-docs-update:**
- Look for `docs/plans/active/` path references
- Ask: "Where do you want dev documentation stored?"
- Update paths in the command files

---

## Common Patterns & Best Practices

### Pattern: Asking About Project Structure

**DON'T assume:**
- "I'll add this for your api service"
- "Configuring for your frontend directory"

**DO ask:**
- "What's your project structure? Monorepo or single app?"
- "Where is your backend code located?"
- "Do you use workspaces or have multiple services?"

### Pattern: settings.json Integration

**NEVER copy the showcase settings.json directly!**

Instead, **extract and merge** the sections they need:

1. Read their existing settings.json
2. Add the hook configurations they want
3. Preserve their existing config

**Example merge:**
```json
{
  // ... their existing config ...
  "hooks": {
    // ... their existing hooks ...
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use-tracker.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/tsc-check.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Verification Checklist

After integration, **verify these items:**

```bash
# 1. Hooks are executable
ls -la $CLAUDE_PROJECT_DIR/.claude/hooks/*.sh
# Should show: -rwxr-xr-x

# 2. Settings.json is valid JSON
cat $CLAUDE_PROJECT_DIR/.claude/settings.json | jq .
# Should parse without errors
```

**Then ask user to test:**
- "Try editing a file in [relevant-path] - the skill should activate"
- "Try asking me a question about [topic] - the skill should be suggested"

---

## Common Mistakes to Avoid

### DON'T: Copy settings.json as-is
**Why:** The Stop hooks may not match the user's project structure
**DO:** Extract only PostToolUse and Stop sections, verify tsc-check works

### DON'T: Skip making hooks executable
**Why:** Hooks won't run without execute permission
**DO:** Always `chmod +x` after copying

### DON'T: Assume monorepo structure
**Why:** Most projects are single-service
**DO:** Ask first, then customize

### DON'T: Add all skills at once
**Why:** Overwhelming and may not all be relevant
**DO:** Ask which skills are relevant to their work

### DON'T: Copy Stop hooks without testing
**Why:** They can block the Stop event if they fail
**DO:** Test manually first, only add if working

---

## Example Integration Conversations

### Example 1: Adding Backend Skill

**User:** "Add the fastapi-backend-guidelines skill to my project"

**Claude should respond:**
```
I'll add the fastapi-backend-guidelines skill. First, I need to understand
your project structure:

1. Is this a monorepo with multiple services, or a single backend application?
2. Where is your backend code located? (e.g., src/, backend/, app/)
3. Do you use FastAPI with SQLModel/SQLAlchemy?
```

**User:** "Single app, code is in backend/, yes we use FastAPI with SQLModel"

**Claude should:**
1. Copy the skill directory
2. Verify the skill description matches their use case
3. Respond:
```
Added fastapi-backend-guidelines skill!

Configuration:
- Skill activates automatically when Claude detects FastAPI/backend context
- Covers DDD patterns, async/await, SQLModel, and testing guidelines

Try it: Ask about backend development patterns and the skill should activate.
```

### Example 2: Setting Up Hooks

**User:** "Set up the hooks for my project"

**Claude should respond:**
```
I'll set up the hook system. There are two hooks available:
1. post-tool-use-tracker - Tracks file changes (essential, no config needed)
2. tsc-check - TypeScript compilation check on Stop (optional, for TS projects)

Do you have a .claude/settings.json file already, or should I create one?
Do you use TypeScript in your project?
```

**User:** "I have settings.json already, and yes I use TypeScript"

**Claude should:**
1. Read their settings.json
2. Copy both hook files
3. Make hooks executable
4. Add hook configurations to their settings.json (preserving existing config)
5. Test tsc-check manually
6. Respond:
```
Hooks installed!

What I did:
- Copied post-tool-use-tracker hook (PostToolUse)
- Copied tsc-check hook (Stop)
- Added both to your settings.json

The post-tool-use-tracker will track file changes automatically.
The tsc-check will verify TypeScript compilation when Claude stops.
```

### Example 3: Adding Agent

**User:** "Add the code-architecture-reviewer agent"

**Claude should:**
```
The code-architecture-reviewer agent reviews code for architectural issues
and best practices. This agent works standalone, no configuration needed.

I'll copy it to your .claude/agents/ directory now.
```

**Then:**
1. Copy the agent file
2. Respond:
```
Added code-architecture-reviewer agent!

Use it by running the Task tool with:
- subagent_type: "code-architecture-reviewer"
- prompt: Description of code to review

The agent will review your code and provide architectural feedback.
```

### Example 4: Tech Stack Mismatch

**User:** "Add the nextjs-frontend-guidelines skill to my Vue project"

**Claude should:**
```
I see you're using Vue. The nextjs-frontend-guidelines skill is specifically
designed for Next.js 15 + Tailwind CSS 4 + shadcn/ui. I have a few options:

Option 1 (Recommended): I can create a vue-dev-guidelines skill using the
Next.js skill as a template. I'll adapt:
- Component patterns for Vue (Composition API)
- Replace shadcn/ui examples with your component library
- Replace App Router patterns with Vue Router
- Keep: File organization, performance principles, TypeScript standards

Option 2: Extract only the framework-agnostic patterns (file organization,
performance, testing) without Next.js-specific code.

Option 3: Skip it and help you create Vue guidelines from scratch.

Which would you prefer?
```

**User:** "Option 1 sounds good, I use Vuetify"

**Claude should:**
1. Copy nextjs-frontend-guidelines as vue-dev-guidelines
2. Go through each resource file
3. Replace Next.js patterns with Vue Composition API
4. Replace shadcn/ui components with Vuetify
5. Update the skill description for Vue context
6. Respond:
```
Created vue-dev-guidelines skill adapted for Vue 3 + Vuetify!

What I changed:
- React Server Components → Vue defineComponent
- shadcn/ui examples → Vuetify components
- Next.js App Router → Vue Router
- File patterns → .vue files

What I kept:
- File organization (features/ pattern)
- Performance optimization strategies
- TypeScript standards
- Loading/error state principles

Try editing a .vue file - the skill should activate.
```

---

## Quick Reference Tables

### What Needs Customization?

| Component | Tech Requirements | Customization | What to Ask |
|-----------|------------------|--------------|-------------|
| **fastapi-backend-guidelines** | FastAPI/SQLModel/Python | Verify description | "Use FastAPI/SQLModel?" |
| **nextjs-frontend-guidelines** | Next.js 15/Tailwind/shadcn | Verify description | "Use Next.js/Tailwind?" |
| **pytest-backend-testing** | Python/pytest | Verify description | "Use pytest?" |
| **error-tracking** | Sentry | Verify description | "Use Sentry?" |
| **mermaid** | None | Copy as-is | - |
| **pdf** / **docx** / **pptx** | None | Copy as-is | - |
| **post-tool-use-tracker** | None | Copy as-is | - |
| **tsc-check** | TypeScript | Test before enabling | "Monorepo or single app?" |
| **All agents** | Minimal | Check paths | - |
| **All commands** | Paths | "Where for dev docs?" | - |

### When to Recommend Skipping

| Component | Skip If... |
|-----------|-----------|
| **tsc-check hook** | No TypeScript in project or non-standard build setup |
| **fastapi-backend-guidelines** | Not using Python/FastAPI |
| **nextjs-frontend-guidelines** | Not using Next.js |
| **pytest-backend-testing** | Not using Python/pytest |

---

## Final Tips for Claude

**When user says "add everything":**
- Start with essentials: post-tool-use-tracker hook + 1-2 relevant skills
- Don't overwhelm them with all skills + agents at once
- Ask what they actually need

**When something doesn't work:**
- Check verification checklist
- Verify paths match their structure
- Test hooks manually
- Check for JSON syntax errors

**When user is unsure:**
- Recommend starting with just post-tool-use-tracker hook
- Add backend OR frontend skill (whichever they use)
- Add more later as needed

**Always explain what you're doing:**
- Show the commands you're running
- Explain why you're asking questions
- Provide clear next steps after integration

---

**Remember:** This is a reference library, not a working application. Your job is to help users cherry-pick and adapt components for THEIR specific project structure.
