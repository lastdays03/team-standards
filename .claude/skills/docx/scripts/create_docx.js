/**
 * DOCX Creation Template
 *
 * Usage: NODE_PATH=$(npm root -g) node create_docx.js [output_path]
 *
 * This template includes all boilerplate:
 * - Styles (Arial, Heading1/2/3 with outlineLevel for TOC)
 * - Numbering (bullets + numbers)
 * - Borders and cell margins
 * - US Letter page setup (12240 x 15840 DXA, 1" margins)
 *
 * Edit the `sections` array below to customize content.
 */

const fs = require("fs");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, ImageRun,
  Header, Footer, AlignmentType, PageOrientation, LevelFormat, ExternalHyperlink,
  TableOfContents, HeadingLevel, BorderStyle, WidthType, ShadingType,
  VerticalAlign, PageNumber, PageBreak
} = require("docx");

// ============================================================
// Pre-configured constants (use these in your sections)
// ============================================================

const BORDER = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: BORDER, bottom: BORDER, left: BORDER, right: BORDER };

const CELL_MARGINS = { top: 80, bottom: 80, left: 120, right: 120 };

// US Letter dimensions
const PAGE_WIDTH = 12240;   // 8.5 inches in DXA
const PAGE_HEIGHT = 15840;  // 11 inches in DXA
const MARGIN = 1440;        // 1 inch in DXA
const CONTENT_WIDTH = PAGE_WIDTH - (MARGIN * 2); // 9360 DXA

// ============================================================
// Styles (Heading1/2/3 with outlineLevel for TOC compatibility)
// ============================================================

const styles = {
  default: {
    document: {
      run: { font: "Arial", size: 24 } // 12pt default
    }
  },
  paragraphStyles: [
    {
      id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
      run: { size: 32, bold: true, font: "Arial" },
      paragraph: { spacing: { before: 240, after: 240 }, outlineLevel: 0 }
    },
    {
      id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
      run: { size: 28, bold: true, font: "Arial" },
      paragraph: { spacing: { before: 180, after: 180 }, outlineLevel: 1 }
    },
    {
      id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
      run: { size: 26, bold: true, font: "Arial" },
      paragraph: { spacing: { before: 120, after: 120 }, outlineLevel: 2 }
    },
  ]
};

// ============================================================
// Numbering (bullets and numbers — never use unicode bullets)
// ============================================================

const numbering = {
  config: [
    {
      reference: "bullets",
      levels: [{
        level: 0, format: LevelFormat.BULLET, text: "\u2022",
        alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } }
      }]
    },
    {
      reference: "numbers",
      levels: [{
        level: 0, format: LevelFormat.DECIMAL, text: "%1.",
        alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } }
      }]
    },
  ]
};

// ============================================================
// Default page properties (US Letter, 1" margins)
// ============================================================

const defaultPageProps = {
  page: {
    size: { width: PAGE_WIDTH, height: PAGE_HEIGHT },
    margin: { top: MARGIN, right: MARGIN, bottom: MARGIN, left: MARGIN }
  }
};

// ============================================================
// YOUR CONTENT: Edit the sections array below
// ============================================================

const sections = [
  {
    properties: defaultPageProps,
    children: [
      new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun("Example Document")]
      }),
      new Paragraph({
        children: [new TextRun("Replace this content with your own.")]
      }),
    ]
  }
];

// ============================================================
// Build and save (do not modify below)
// ============================================================

const outputPath = process.argv[2] || "output.docx";

const doc = new Document({ styles, numbering, sections });

Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync(outputPath, buffer);
  console.log(`Created: ${outputPath} (${buffer.length} bytes)`);
});
