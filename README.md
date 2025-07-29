# Calculator

A simple, clean web calculator built with HTML, CSS, and JavaScript.

## Features

- Basic arithmetic operations (+, -, ×, ÷)
- Decimal number support
- Percentage calculations
- Sign toggle (+/-)
- Clear all (AC) functionality
- Keyboard support
- Responsive design with iOS-style interface

## Usage

1. Open `calculator.html` in a web browser
2. Click buttons or use keyboard shortcuts:
   - Numbers: 0-9
   - Operations: +, -, *, /
   - Calculate: Enter or =
   - Clear: Escape, C, or c
   - Decimal: .
   - Percentage: %

## Files

- `calculator.html` - Main HTML structure
- `script.js` - Calculator logic and functionality
- `styles.css` - Styling and layout

## How to Run

Simply open `calculator.html` in any modern web browser. No server or additional setup required.

## Git Auto-Commit Configuration

```yaml
# Auto-commit settings (parsed by file watcher script)
repository: https://github.com/nuckecy/Figma-Calculator.git
branch: main
auto_commit: enabled
watch_files: "*"
commit_template: "{instruction} - {filename} - {timestamp}"
push_enabled: true
last_instruction: "Let update the commit message"
```

## Development Guidelines

**Important:** This project uses automatic git commits when files change. The auto-commit system is configured above and monitors ALL files in the project folder for changes.

**Commit Messages:** The system uses your latest instruction (stored in `last_instruction`) as the commit message. If the instruction is longer than 6 words, it will be truncated.

**To update the instruction:** Use `./update-instruction.sh "Your new instruction here"`

**To start the auto-commit watcher:** Run `./auto-git-watcher.sh`

Manual commit (if needed):
```bash
git add .
git commit -m "Description of changes made"
git push origin main
```