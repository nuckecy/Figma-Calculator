#!/bin/bash

# Helper script to update the last_instruction in README.md
# Usage: ./update-instruction.sh "Your new instruction here"

INSTRUCTION="$1"
README_FILE="README.md"

if [[ -z "$INSTRUCTION" ]]; then
    echo "Usage: $0 \"Your instruction here\""
    echo "Example: $0 \"Change the title to something else\""
    exit 1
fi

# Escape special characters for sed
ESCAPED_INSTRUCTION=$(echo "$INSTRUCTION" | sed 's/[[\.*^$()+?{|]/\\&/g')

# Update the last_instruction line in README.md
if grep -q "last_instruction:" "$README_FILE"; then
    sed -i '' "s/last_instruction: .*/last_instruction: \"$ESCAPED_INSTRUCTION\"/" "$README_FILE"
    echo "✅ Updated instruction to: $INSTRUCTION"
else
    echo "❌ Could not find last_instruction line in $README_FILE"
    exit 1
fi