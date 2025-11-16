---
name: shot-scraper
description: Automated screenshot capture tool for websites using a cli tool named 'shot-scraper'. Use for taking screenshots, generating PDFs, accessibility testing, HAR recording, and multi-page batch captures.
allowed-tools: Bash, Read, Write
---

# Shot Scraper Skill

This skill provides automated screenshot capabilities using the shot-scraper tool.

## Common Usage Patterns

### Basic Screenshots
```bash
# Full page screenshot
shot-scraper https://example.com

# With specific dimensions
shot-scraper https://example.com -h 900 -w 1200

# Wait for element before shooting
shot-scraper https://example.com --selector "#loaded-content"
```

### Element-Specific Screenshots
```bash
# Capture specific CSS selector
shot-scraper https://example.com --selector ".hero-section"

# Multiple selectors
shot-scraper https://example.com --selector ".header" --selector ".footer"
```

### JavaScript Execution
```bash
# Execute JavaScript before screenshot
shot-scraper https://example.com --javascript "window.scrollTo(0, 500)"
```

### PDF Generation
```bash
# Create PDF from page
shot-scraper pdf https://example.com -o output.pdf
```

### Multi-Page Batch Processing
Create a YAML file (e.g., `screenshots.yml`):
```yaml
- output: example-home.png
  url: https://example.com
  height: 800
- output: example-about.png
  url: https://example.com/about
  selector: ".main-content"
```

Then run:
```bash
shot-scraper multi screenshots.yml
```

### Accessibility and Debugging
```bash
# Get accessibility tree
shot-scraper accessibility https://example.com

# Record HAR file for performance analysis
shot-scraper har https://example.com -o network.har

# Get final HTML after JavaScript execution
shot-scraper html https://example.com -o rendered.html
```

### Authentication Flows
For sites requiring login:
```bash
# Open browser for manual authentication
shot-scraper auth https://example.com/login
```

This opens a browser where you can log in manually, then subsequent commands will use the authenticated session.

## Available Commands

- `shot-scraper shot`: Take single screenshots
- `shot-scraper multi`: Batch screenshots from YAML
- `shot-scraper pdf`: Generate PDF files
- `shot-scraper accessibility`: Extract accessibility trees
- `shot-scraper har`: Record network activity
- `shot-scraper html`: Get rendered HTML
- `shot-scraper javascript`: Execute JavaScript
- `shot-scraper auth`: Manual authentication
- `shot-scraper install`: Install browser dependencies

## File Operations

The skill mounts your home directory and preserves the current working directory, allowing:
- Reading local configuration files
- Writing screenshots to current directory
- Accessing local files for batch processing
