# Hooks Configuration Guide

This guide explains how to configure and customize the hooks system for your project.

## Quick Start Configuration

### 1. Register Hooks in .claude/settings.json

Create or update `.claude/settings.json` in your project root:

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

### 2. Set Execute Permissions

```bash
chmod +x .claude/hooks/*.sh
```

## Customization Options

### Project Structure Detection

By default, hooks detect these directory patterns:

**Frontend:** `frontend/`, `client/`, `web/`, `app/`, `ui/`
**Backend:** `backend/`, `server/`, `api/`, `src/`, `services/`
**Database:** `database/`, `prisma/`, `migrations/`
**Monorepo:** `packages/*`, `examples/*`

#### Adding Custom Directory Patterns

Edit `.claude/hooks/post-tool-use-tracker.sh`, function `detect_repo()`:

```bash
case "$repo" in
    # Add your custom directories here
    my-custom-service)
        echo "$repo"
        ;;
    admin-panel)
        echo "$repo"
        ;;
    # ... existing patterns
esac
```

### Build Command Detection

The hooks auto-detect build commands based on:
1. Presence of `package.json` with "build" script
2. Package manager (pnpm > npm > yarn)
3. Special cases (Prisma schemas)

#### Customizing Build Commands

Edit `.claude/hooks/post-tool-use-tracker.sh`, function `get_build_command()`:

```bash
# Add custom build logic
if [[ "$repo" == "my-service" ]]; then
    echo "cd $repo_path && make build"
    return
fi
```

### TypeScript Configuration

Hooks automatically detect:
- `tsconfig.json` for standard TypeScript projects
- `tsconfig.app.json` for Vite/React projects

#### Custom TypeScript Configs

Edit `.claude/hooks/post-tool-use-tracker.sh`, function `get_tsc_command()`:

```bash
if [[ "$repo" == "my-service" ]]; then
    echo "cd $repo_path && npx tsc --project tsconfig.build.json --noEmit"
    return
fi
```

## Environment Variables

### Global Environment Variables

Set in your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
# Custom project directory (if not using default)
export CLAUDE_PROJECT_DIR=/path/to/your/project
```

### Per-Session Environment Variables

Set before starting Claude Code:

```bash
CLAUDE_PROJECT_DIR=/path/to/project claude-code
```

## Hook Execution Order

Stop hooks run in the order specified in `settings.json`:

```json
"Stop": [
  {
    "hooks": [
      { "command": "...tsc-check.sh" }    // TypeScript compilation check
    ]
  }
]
```

## Selective Hook Enabling

You don't need all hooks. Choose what works for your project:

### File Tracking Only (No Build Checking)

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

### Full Setup (Tracking + TypeScript Check)

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

## Cache Management

### Cache Location

```
$CLAUDE_PROJECT_DIR/.claude/tsc-cache/[session_id]/
```

The `session_id` is read from stdin JSON by the tsc-check hook.

### Manual Cache Cleanup

```bash
# Remove all cached data
rm -rf $CLAUDE_PROJECT_DIR/.claude/tsc-cache/*

# Remove specific session
rm -rf $CLAUDE_PROJECT_DIR/.claude/tsc-cache/[session-id]
```

### Automatic Cleanup

The tsc-check hook automatically cleans up session cache on successful builds.

## Troubleshooting Configuration

### Hook Not Executing

1. **Check registration:** Verify hook is in `.claude/settings.json`
2. **Check permissions:** Run `chmod +x .claude/hooks/*.sh`
3. **Check path:** Ensure `$CLAUDE_PROJECT_DIR` is set correctly

### False Positive Detections

**Issue:** Hook triggers for files it shouldn't

**Solution:** Add skip conditions in the relevant hook:

```bash
# In post-tool-use-tracker.sh
if [[ "$file_path" =~ /generated/ ]]; then
    exit 0  # Skip generated files
fi
```

### Performance Issues

**Issue:** Hooks are slow

**Solutions:**
1. Limit TypeScript checks to changed files only
2. Use faster package managers (pnpm > npm)
3. Add more skip conditions

### Debugging Hooks

Add debug output to any hook:

```bash
# At the top of the hook script
set -x  # Enable debug mode

# Or add specific debug lines
echo "DEBUG: file_path=$file_path" >&2
echo "DEBUG: repo=$repo" >&2
```

View hook execution in Claude Code's logs.

## Advanced Configuration

### Custom Hook Event Handlers

You can create your own hooks for other events:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/my-custom-bash-guard.sh"
          }
        ]
      }
    ]
  }
}
```

### Monorepo Configuration

For monorepos with multiple packages:

```bash
# In post-tool-use-tracker.sh, detect_repo()
case "$repo" in
    packages)
        # Get the package name
        local package=$(echo "$relative_path" | cut -d'/' -f2)
        if [[ -n "$package" ]]; then
            echo "packages/$package"
        else
            echo "$repo"
        fi
        ;;
esac
```

### Docker/Container Projects

If your build commands need to run in containers:

```bash
# In post-tool-use-tracker.sh, get_build_command()
if [[ "$repo" == "api" ]]; then
    echo "docker-compose exec api npm run build"
    return
fi
```

## Best Practices

1. **Start minimal** - Enable hooks one at a time
2. **Test thoroughly** - Make changes and verify hooks work
3. **Document customizations** - Add comments to explain custom logic
4. **Version control** - Commit `.claude/` directory to git
5. **Team consistency** - Share configuration across team

## See Also

- [README.md](./README.md) - Hooks overview
