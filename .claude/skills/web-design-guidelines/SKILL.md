---
name: web-design-guidelines
description: "Review UI code for Web Interface Guidelines compliance — covers 79+ rules across accessibility, forms, interactive states, navigation, and design quality (visual hierarchy, spacing, color contrast, component consistency, empty/loading/error states, responsive quality, icon sizing, border/shadow consistency). Use this skill whenever the user asks to review, audit, or check any aspect of their UI: button styles, spacing issues, dark mode contrast, touch targets, keyboard accessibility, focus states, empty state handling, loading feedback, icon consistency, form validation UX, or any visual/interaction quality concern. Also trigger on 'UI 리뷰', '접근성 점검', '디자인 감사', 'UX 검토', '웹 표준 점검', '간격 문제', '대비 부족', '빈 상태', '로딩 상태', '일관성 체크', '반응형 품질', or any mention of UI inconsistency, design quality issues, or WCAG compliance."
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

## Workflow

This skill is the **review/audit** counterpart to the `frontend-design` skill:

- **frontend-design** → Creates distinctive, production-grade UI (generation)
- **web-design-guidelines** → Reviews UI code for compliance and quality (inspection)

**Recommended flow**: After generating UI with `frontend-design`, run this skill on the output files to catch accessibility issues, missing states, and design quality problems before shipping.
