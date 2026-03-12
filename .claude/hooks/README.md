# Hooks

Claude Code hooks that enable file tracking and TypeScript validation.

---

## What Are Hooks?

Hooks are scripts that run at specific points in Claude's workflow:
- **PostToolUse**: After a tool completes
- **Stop**: When Claude stops generating

**Key insight:** Hooks can modify prompts, block actions, and track state - enabling features Claude can't do alone.

---

## Essential Hooks

### post-tool-use-tracker (PostToolUse)

**Purpose:** Tracks file changes to maintain context across sessions

**How it works:**
1. Monitors Edit/Write/MultiEdit tool calls
2. Records which files were modified
3. Creates cache for context management
4. Auto-detects project structure (frontend, backend, packages, etc.)

**Why it's essential:** Helps Claude understand what parts of your codebase are active.

**Integration:**
```bash
# Copy file
cp post-tool-use-tracker.sh your-project/.claude/hooks/

# Make executable
chmod +x your-project/.claude/hooks/post-tool-use-tracker.sh
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

**Customization:** None needed - auto-detects structure

---

## Optional Hooks (Require Customization)

### tsc-check (Stop)

**Purpose:** TypeScript compilation check when Claude stops

**How it works:**
1. Reads `session_id` from stdin JSON
2. Uses cache at `$CLAUDE_PROJECT_DIR/.claude/tsc-cache/[session_id]/` to find changed files
3. Detects repo structure using the same pattern as post-tool-use-tracker (auto-detect project directories)
4. Supports Write/Edit/MultiEdit tool changes tracked by post-tool-use-tracker

**WARNING:** Configured for multi-service monorepo structure

**Integration:**

**First, determine if this is right for you:**
- Use if: Multi-service TypeScript monorepo
- Skip if: Single-service project or different build setup

**If using:**
1. Copy tsc-check.sh
2. **EDIT the service detection (line ~28):**
   ```bash
   # Replace example services with YOUR services:
   case "$repo" in
       api|web|auth|payments|...)  # <- Your actual services
   ```
3. Test manually before adding to settings.json

**Customization:** Heavy - service detection must match your project

---

## Testing

The `fixtures/` directory contains smoke test payloads for validating hook behavior:
- `stop-edit.json` — simulates an Edit tool event
- `stop-write.json` — simulates a Write tool event
- `stop-multiedit.json` — simulates a MultiEdit tool event

These can be piped into hooks via stdin for local testing.

---

## For Claude Code

**When setting up hooks for a user:**

1. **Read [CLAUDE_INTEGRATION_GUIDE.md](../../CLAUDE_INTEGRATION_GUIDE.md)** first
2. **Start with post-tool-use-tracker** - it is the essential hook for file change tracking
3. **Ask before adding the tsc-check Stop hook** - it can block if misconfigured
4. **Verify after setup:**
   ```bash
   ls -la .claude/hooks/*.sh | grep rwx
   ```

**Questions?** See [CLAUDE_INTEGRATION_GUIDE.md](../../CLAUDE_INTEGRATION_GUIDE.md)
