---
name: web-design-guidelines
description: "Review UI code for Web Interface Guidelines compliance. Use when asked to 'review my UI', 'check accessibility', 'audit design', 'review UX', or 'check my site against best practices'. Also trigger when 'UI 리뷰', '접근성 점검', '디자인 감사', 'UX 검토', '웹 표준 점검', or any UI/UX compliance review."
metadata:
  author: vercel
  version: "1.1.0"
  argument-hint: <file-or-pattern>
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Read the guidelines from `references/guidelines.md` (bundled with this skill)
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the guidelines
4. Output findings in the terse `file:line` format

## Guidelines Reference

The full ruleset is bundled locally at `references/guidelines.md`. Read this file to get all rules and the output format specification. No external fetch needed.

## Usage

When a user provides a file or pattern argument:
1. Read `references/guidelines.md` from this skill's directory
2. Read the specified files
3. Apply all rules from the guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.
