#!/bin/bash

echo "Testing final auto-commit functionality..."

# Start watcher in background
./auto-git-watcher.sh &
WATCHER_PID=$!

echo "Watcher started with PID: $WATCHER_PID"
echo "Waiting 3 seconds for initialization..."
sleep 3

# Make a small change to test
echo "Making test change to calculator.html..."
echo "<!-- Test change -->" >> calculator.html

echo "Waiting 8 seconds for detection and commit..."
sleep 8

# Check latest commit
echo "Latest commit:"
git log --oneline -1

# Stop watcher
echo "Stopping watcher..."
kill $WATCHER_PID 2>/dev/null

echo "Test completed!"