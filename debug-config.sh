#!/bin/bash

# Debug script to test configuration parsing

README_FILE="README.md"

echo "=== Testing Configuration Parsing ==="

# Extract values the same way the main script does
LAST_INSTRUCTION=$(grep "last_instruction:" "$README_FILE" | sed 's/last_instruction: *//' | tr -d '"' | tr -d "'")
COMMIT_TEMPLATE=$(grep "commit_template:" "$README_FILE" | sed 's/commit_template: *//' | tr -d '"' | tr -d "'")

echo "Raw LAST_INSTRUCTION: '$LAST_INSTRUCTION'"
echo "Raw COMMIT_TEMPLATE: '$COMMIT_TEMPLATE'"
echo "Length of LAST_INSTRUCTION: ${#LAST_INSTRUCTION}"

# Test the generate_commit_message logic
generate_commit_message() {
    local filename="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="$COMMIT_TEMPLATE"
    
    echo "  Inside function - LAST_INSTRUCTION: '$LAST_INSTRUCTION'"
    echo "  Inside function - COMMIT_TEMPLATE: '$COMMIT_TEMPLATE'"
    
    # Get instruction and truncate to first 6 words if too long
    local instruction="$LAST_INSTRUCTION"
    if [[ -z "$instruction" ]]; then
        instruction="Auto-update"
        echo "  Instruction was empty, using default: '$instruction'"
    else
        echo "  Using instruction: '$instruction'"
        # Split instruction into words and take first 6
        local words=($instruction)
        echo "  Number of words: ${#words[@]}"
        if [[ ${#words[@]} -gt 6 ]]; then
            instruction="${words[0]} ${words[1]} ${words[2]} ${words[3]} ${words[4]} ${words[5]}"
            echo "  Truncated to: '$instruction'"
        fi
    fi
    
    echo "  Final instruction to use: '$instruction'"
    
    # Replace placeholders
    echo "  Before replacement: '$message'"
    message="${message//\{filename\}/$filename}"
    message="${message//\{timestamp\}/$timestamp}"
    message="${message//\{instruction\}/$instruction}"
    echo "  After replacement: '$message'"
    
    echo "$message"
}

echo ""
echo "=== Testing generate_commit_message ==="
result=$(generate_commit_message "test.html")
echo ""
echo "Final result: '$result'"