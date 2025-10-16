# Converting Mermaid Diagrams to PNG

## Method 1: Using Mermaid Live Editor (Recommended)

1. **Open the HTML file**: Open `ci-cd-diagrams.html` in your browser to see the rendered diagrams
2. **Use Mermaid Live Editor**: Go to [https://mermaid.live](https://mermaid.live)
3. **Copy the diagram code**: 
   - Copy content from `high-level-architecture.mmd`
   - Paste into the editor
   - Click "Actions" → "Download PNG" or "Download SVG"

## Method 2: Using Mermaid CLI (if Node.js is available)

```bash
# Install Mermaid CLI globally
npm install -g @mermaid-js/mermaid-cli

# Convert to PNG
mmdc -i high-level-architecture.mmd -o high-level-architecture.png
mmdc -i merge-flow.mmd -o merge-flow.png

# Convert to SVG (vector format)
mmdc -i high-level-architecture.mmd -o high-level-architecture.svg
mmdc -i merge-flow.mmd -o merge-flow.svg
```

## Method 3: Using Online Converters

1. **Mermaid Chart**: [https://www.mermaidchart.com](https://www.mermaidchart.com)
2. **Kroki**: [https://kroki.io](https://kroki.io)
3. **Draw.io**: Import Mermaid code directly

## Method 4: Browser Screenshot

1. Open `ci-cd-diagrams.html` in your browser
2. Use browser's developer tools to screenshot the diagram elements
3. Or use browser extensions like "Full Page Screen Capture"

## Diagram Files Created

- `high-level-architecture.mmd` - Main architecture diagram
- `merge-flow.mmd` - Merge flow process diagram  
- `ci-cd-diagrams.html` - Complete HTML with both diagrams
- `convert-to-png.md` - This conversion guide

## Quick Start

1. **View diagrams**: Open `ci-cd-diagrams.html` in your browser
2. **Copy for use**: Use the `.mmd` files in documentation or online editors
3. **Convert to images**: Use any of the methods above to get PNG/SVG files

The HTML file provides the best viewing experience with interactive diagrams and detailed descriptions.
