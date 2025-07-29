#!/bin/bash

# Test script to verify auto-git-watcher functionality

echo "Testing auto-git-watcher functionality..."

# Start the watcher in background
./auto-git-watcher.sh &
WATCHER_PID=$!

echo "Watcher started with PID: $WATCHER_PID"
echo "Waiting 3 seconds for watcher to initialize..."
sleep 3

# Make a test change to HTML file
echo "Making test change to calculator.html..."
sed -i '' 's/Test Auto Commit/Test Auto Commit Working/g' calculator.html

echo "Waiting 5 seconds for watcher to detect and commit..."  
sleep 5

# Check if commit was made
LATEST_COMMIT=$(git log --oneline -1 | grep "Auto-update")
if [[ -n "$LATEST_COMMIT" ]]; then
    echo "✅ SUCCESS: Auto-commit detected!"
    echo "Latest commit: $LATEST_COMMIT"
else
    echo "❌ FAILED: No auto-commit detected"
    echo "Latest commit: $(git log --oneline -1)"
fi

# Stop the watcher
echo "Stopping watcher..."
kill $WATCHER_PID 2>/dev/null

echo "Test completed."