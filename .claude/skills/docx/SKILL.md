---
name: docx
description: "Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx files). Triggers include: any mention of \"Word doc\", \"word document\", \".docx\", or requests to produce professional documents with formatting like tables of contents, headings, page numbers, or letterheads. Also use when extracting or reorganizing content from .docx files, inserting or replacing images in documents, performing find-and-replace in Word files, working with tracked changes or comments, or converting content into a polished Word document. If the user asks for a \"report\", \"memo\", \"letter\", \"template\", or similar deliverable as a Word or .docx file, use this skill. Also trigger when '워드 문서', '문서 작성', '보고서 작성', '워드 편집', '문서 템플릿', or '.docx 파일'. Do NOT use for PDFs, spreadsheets, Google Docs, or general coding tasks unrelated to document generation."
license: Proprietary. LICENSE.txt has complete terms
---

# DOCX creation, editing, and analysis

## Overview

A .docx file is a ZIP archive containing XML files.

**Script location:** All scripts referenced in this skill are relative to this skill's directory. Resolve the absolute path using:
```bash
SKILL_DIR="$(dirname "$(find .claude/skills/docx -name SKILL.md -print -quit 2>/dev/null || echo .claude/skills/docx/SKILL.md)")"
```

## Setup & Dependencies

```bash
# Required: pandoc (text extraction & format conversion)
brew install pandoc          # macOS
apt-get install pandoc       # Ubuntu/Debian

# Required: Node.js docx package (document creation)
npm install -g docx

# Optional: LibreOffice (PDF conversion, .doc → .docx conversion)
brew install --cask libreoffice   # macOS

# Optional: Poppler (PDF to image conversion)
brew install poppler              # macOS
apt-get install poppler-utils     # Ubuntu/Debian
```

**Verify installation (IMPORTANT: always use NODE_PATH for global packages):**
```bash
export NODE_PATH=$(npm root -g)
pandoc --version && NODE_PATH=$(npm root -g) node -e "require('docx')" && echo "All dependencies OK"
```

## Quick Reference

| Task | Approach |
|------|----------|
| Read/analyze content | `pandoc` or unpack for raw XML |
| Create new document | Use `scripts/create_docx.js` template — see Creating New Documents |
| Edit existing document | Unpack → edit XML → repack — see `references/editing-guide.md` |

### Converting .doc to .docx

Legacy `.doc` files must be converted before editing:

```bash
python "$SKILL_DIR/scripts/office/soffice.py" --headless --convert-to docx document.doc
```

### Reading Content

```bash
# Text extraction with tracked changes
pandoc --track-changes=all document.docx -o output.md

# Raw XML access
python "$SKILL_DIR/scripts/office/unpack.py" document.docx unpacked/
```

### Converting to Images

```bash
python "$SKILL_DIR/scripts/office/soffice.py" --headless --convert-to pdf document.docx
pdftoppm -jpeg -r 150 document.pdf page
```

### Accepting Tracked Changes

To produce a clean document with all tracked changes accepted (requires LibreOffice):

```bash
python "$SKILL_DIR/scripts/accept_changes.py" input.docx output.docx
```

---

## Creating New Documents

Use `scripts/create_docx.js` as the starting template. It includes all boilerplate (styles, numbering, borders, page setup) — you only need to fill in the `sections` array.

### Workflow

```bash
# 1. Copy the template and customize the sections array
cp "$SKILL_DIR/scripts/create_docx.js" /tmp/my_doc.js
# Edit /tmp/my_doc.js — replace the example sections with your content

# 2. Run with NODE_PATH (required for global npm packages)
NODE_PATH=$(npm root -g) node /tmp/my_doc.js

# 3. Validate
python "$SKILL_DIR/scripts/office/validate.py" output.docx
```

### What the template provides

The template (`scripts/create_docx.js`) pre-configures:
- **Styles**: Arial font, Heading1/2/3 with `outlineLevel` (required for TOC)
- **Numbering**: bullets (`LevelFormat.BULLET`) and numbers (`LevelFormat.DECIMAL`)
- **Borders**: standard light gray cell borders
- **Page setup**: US Letter (12240 x 15840 DXA), 1" margins
- **Cell margins**: `{ top: 80, bottom: 80, left: 120, right: 120 }`
- **Output**: reads output path from `process.argv[2]` (default: `output.docx`)

You only need to edit the `sections` array in the template.

### Page Size

```javascript
// CRITICAL: docx-js defaults to A4, not US Letter
// The template already sets US Letter — override only if needed
sections: [{
  properties: {
    page: {
      size: {
        width: 12240,   // 8.5 inches in DXA
        height: 15840   // 11 inches in DXA
      },
      margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } // 1 inch margins
    }
  },
  children: [/* content */]
}]
```

**Common page sizes (DXA units, 1440 DXA = 1 inch):**

| Paper | Width | Height | Content Width (1" margins) |
|-------|-------|--------|---------------------------|
| US Letter | 12,240 | 15,840 | 9,360 |
| A4 (default) | 11,906 | 16,838 | 9,026 |

**Landscape orientation:** docx-js swaps width/height internally, so pass portrait dimensions and let it handle the swap:
```javascript
size: {
  width: 12240,   // Pass SHORT edge as width
  height: 15840,  // Pass LONG edge as height
  orientation: PageOrientation.LANDSCAPE  // docx-js swaps them in the XML
},
// Content width = 15840 - left margin - right margin (uses the long edge)
```

### Tables

**CRITICAL: Tables need dual widths** - set both `columnWidths` on the table AND `width` on each cell. Without both, tables render incorrectly on some platforms.

```javascript
// Use the pre-defined helpers from the template:
// borders, CELL_MARGINS, WidthType.DXA, ShadingType.CLEAR
new Table({
  width: { size: 9360, type: WidthType.DXA }, // Always use DXA (percentages break in Google Docs)
  columnWidths: [4680, 4680], // Must sum to table width (DXA: 1440 = 1 inch)
  rows: [
    new TableRow({
      children: [
        new TableCell({
          borders,
          width: { size: 4680, type: WidthType.DXA }, // Also set on each cell
          shading: { fill: "D5E8F0", type: ShadingType.CLEAR }, // CLEAR not SOLID
          margins: CELL_MARGINS,
          children: [new Paragraph({ children: [new TextRun("Cell")] })]
        })
      ]
    })
  ]
})
```

**Width rules:**
- **Always use `WidthType.DXA`** — never `WidthType.PERCENTAGE` (incompatible with Google Docs)
- Table width must equal the sum of `columnWidths`
- Cell `width` must match corresponding `columnWidth`
- Cell `margins` are internal padding - they reduce content area, not add to cell width
- For full-width tables: use content width (page width minus left and right margins)

### Lists (NEVER use unicode bullets)

```javascript
// ❌ WRONG - never manually insert bullet characters
new Paragraph({ children: [new TextRun("• Item")] })  // BAD
new Paragraph({ children: [new TextRun("\u2022 Item")] })  // BAD

// ✅ CORRECT - use the template's pre-configured numbering
new Paragraph({ numbering: { reference: "bullets", level: 0 },
  children: [new TextRun("Bullet item")] }),
new Paragraph({ numbering: { reference: "numbers", level: 0 },
  children: [new TextRun("Numbered item")] }),

// ⚠️ Each reference creates INDEPENDENT numbering
// Same reference = continues (1,2,3 then 4,5,6)
// Different reference = restarts (1,2,3 then 1,2,3)
```

### Images

```javascript
// CRITICAL: type parameter is REQUIRED
new Paragraph({
  children: [new ImageRun({
    type: "png", // Required: png, jpg, jpeg, gif, bmp, svg
    data: fs.readFileSync("image.png"),
    transformation: { width: 200, height: 150 },
    altText: { title: "Title", description: "Desc", name: "Name" } // All three required
  })]
})
```

### Page Breaks

```javascript
// CRITICAL: PageBreak must be inside a Paragraph
new Paragraph({ children: [new PageBreak()] })

// Or use pageBreakBefore
new Paragraph({ pageBreakBefore: true, children: [new TextRun("New page")] })
```

### Table of Contents

```javascript
// CRITICAL: Headings must use HeadingLevel ONLY - no custom styles
new TableOfContents("Table of Contents", { hyperlink: true, headingStyleRange: "1-3" })
```

### Headers/Footers

```javascript
sections: [{
  properties: {
    page: { margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } }
  },
  headers: {
    default: new Header({ children: [new Paragraph({ children: [new TextRun("Header")] })] })
  },
  footers: {
    default: new Footer({ children: [new Paragraph({
      children: [new TextRun("Page "), new TextRun({ children: [PageNumber.CURRENT] })]
    })] })
  },
  children: [/* content */]
}]
```

### Critical Rules for docx-js

- **Set page size explicitly** - docx-js defaults to A4; use US Letter (12240 x 15840 DXA) for US documents
- **Landscape: pass portrait dimensions** - docx-js swaps width/height internally; pass short edge as `width`, long edge as `height`, and set `orientation: PageOrientation.LANDSCAPE`
- **Never use `\n`** - use separate Paragraph elements
- **Never use unicode bullets** - use `LevelFormat.BULLET` with numbering config (also applies inside table cells)
- **PageBreak must be in Paragraph** - standalone creates invalid XML
- **ImageRun requires `type`** - always specify png/jpg/etc
- **Always set table `width` with DXA** - never use `WidthType.PERCENTAGE` (breaks in Google Docs)
- **Tables need dual widths** - `columnWidths` array AND cell `width`, both must match
- **Table width = sum of columnWidths** - for DXA, ensure they add up exactly
- **Always add cell margins** - use `margins: CELL_MARGINS` from template
- **Use `ShadingType.CLEAR`** - never SOLID for table shading (SOLID causes black backgrounds)
- **TOC requires HeadingLevel only** - no custom styles on heading paragraphs
- **Override built-in styles** - use exact IDs: "Heading1", "Heading2", etc.
- **Include `outlineLevel`** - required for TOC (0 for H1, 1 for H2, etc.)

---

## Editing Existing Documents

For editing existing .docx files (tracked changes, comments, XML manipulation), read `references/editing-guide.md` for the full workflow and XML reference.

**Quick summary:**
1. **Unpack**: `python "$SKILL_DIR/scripts/office/unpack.py" document.docx unpacked/`
2. **Edit XML** in `unpacked/word/` using the Edit tool
3. **Pack**: `python "$SKILL_DIR/scripts/office/pack.py" unpacked/ output.docx --original document.docx`

**Adding comments**: `python "$SKILL_DIR/scripts/comment.py" unpacked/ 0 "Comment text"`

---

## Dependencies

- **pandoc**: Text extraction
- **docx**: `npm install -g docx` (new documents) — always run with `NODE_PATH=$(npm root -g)`
- **LibreOffice**: PDF conversion (auto-configured for sandboxed environments via `scripts/office/soffice.py`)
- **Poppler**: `pdftoppm` for images
