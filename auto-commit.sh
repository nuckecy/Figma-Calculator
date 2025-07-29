#!/bin/bash
# File watcher script for auto-committing changes
# Install fswatch: brew install fswatch

fswatch -o . | while read f; do
  if [[ ! "$f" =~ \.git ]]; then
    git add .
    git commit -m "Auto-commit: $(date)"
    git push origin main
  fi
done