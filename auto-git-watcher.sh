#!/bin/bash

# Smart Git Auto-Commit Watcher
# Reads configuration from README.md and auto-commits file changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
README_FILE="$SCRIPT_DIR/README.md"
LOG_FILE="$SCRIPT_DIR/auto-git-watcher.log"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to parse configuration from README.md
parse_config() {
    if [[ ! -f "$README_FILE" ]]; then
        log_message "ERROR: README.md not found at $README_FILE"
        exit 1
    fi
    
    # Extract configuration values from README.md YAML block
    REPOSITORY=$(grep "repository:" "$README_FILE" | sed 's/repository: *//' | tr -d '"' | tr -d "'")
    BRANCH=$(grep "branch:" "$README_FILE" | sed 's/branch: *//' | tr -d '"' | tr -d "'")
    AUTO_COMMIT=$(grep "auto_commit:" "$README_FILE" | sed 's/auto_commit: *//' | tr -d '"' | tr -d "'")
    WATCH_FILES=$(grep "watch_files:" "$README_FILE" | sed 's/watch_files: *//' | tr -d '"' | tr -d "'")
    COMMIT_TEMPLATE=$(grep "commit_template:" "$README_FILE" | sed 's/commit_template: *//' | tr -d '"' | tr -d "'")
    PUSH_ENABLED=$(grep "push_enabled:" "$README_FILE" | sed 's/push_enabled: *//' | tr -d '"' | tr -d "'")
    LAST_INSTRUCTION=$(grep "last_instruction:" "$README_FILE" | sed 's/last_instruction: *//' | tr -d '"' | tr -d "'")
    
    # Set defaults if not found
    REPOSITORY=${REPOSITORY:-"origin"}
    BRANCH=${BRANCH:-"main"}
    AUTO_COMMIT=${AUTO_COMMIT:-"enabled"}
    WATCH_FILES=${WATCH_FILES:-"*.html,*.css,*.js"}
    COMMIT_TEMPLATE=${COMMIT_TEMPLATE:-"Auto-update {filename} - {timestamp}"}
    PUSH_ENABLED=${PUSH_ENABLED:-"true"}
    
    log_message "Configuration loaded:"
    log_message "  Repository: $REPOSITORY"
    log_message "  Branch: $BRANCH"
    log_message "  Auto-commit: $AUTO_COMMIT"
    log_message "  Watch files: $WATCH_FILES"
    log_message "  Push enabled: $PUSH_ENABLED"
}

# Function to generate commit message
generate_commit_message() {
    local filename="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="$COMMIT_TEMPLATE"
    
    # Replace placeholders
    message="${message//\{filename\}/$filename}"
    message="${message//\{timestamp\}/$timestamp}"
    
    echo "$message"
}

# Function to commit and push changes
commit_changes() {
    local changed_file="$1"
    
    if [[ "$AUTO_COMMIT" != "enabled" ]]; then
        log_message "Auto-commit is disabled. Skipping commit for $changed_file"
        return
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_message "ERROR: Not in a git repository"
        return
    fi
    
    # Generate commit message
    local commit_msg=$(generate_commit_message "$(basename "$changed_file")")
    
    # Add and commit changes
    git add .
    if git commit -m "$commit_msg"; then
        log_message "Successfully committed changes: $commit_msg"
        
        # Push if enabled
        if [[ "$PUSH_ENABLED" == "true" ]]; then
            if git push origin "$BRANCH"; then
                log_message "Successfully pushed to $REPOSITORY ($BRANCH)"
            else
                log_message "ERROR: Failed to push to remote repository"
            fi
        fi
    else
        log_message "No changes to commit"
    fi
}

# Function to check if file matches watch patterns
should_watch_file() {
    local file="$1"
    local patterns="$WATCH_FILES"
    
    # If pattern is "*", watch all files
    if [[ "$patterns" == "*" ]]; then
        return 0
    fi
    
    # Convert comma-separated patterns to array
    IFS=',' read -ra PATTERNS <<< "$patterns"
    
    for pattern in "${PATTERNS[@]}"; do
        pattern=$(echo "$pattern" | xargs) # Trim whitespace
        if [[ "$file" == $pattern ]]; then
            return 0
        fi
    done
    
    return 1
}

# Main function
main() {
    log_message "Starting Auto-Git Watcher..."
    
    # Parse configuration
    parse_config
    
    # Check if fswatch is available
    if ! command -v fswatch &> /dev/null; then
        log_message "ERROR: fswatch is not installed. Please install it with: brew install fswatch"
        exit 1
    fi
    
    log_message "Watching directory: $SCRIPT_DIR"
    log_message "Press Ctrl+C to stop watching..."
    
    # Start watching files
    fswatch -e ".git" -e "*.log" -e "*.tmp" -e "*~" -0 "$SCRIPT_DIR" | while IFS= read -r -d '' file; do
        # Get relative path
        relative_file=$(realpath --relative-to="$SCRIPT_DIR" "$file" 2>/dev/null || basename "$file")
        
        log_message "File changed: $relative_file"
        
        # Check if file matches watch patterns
        if should_watch_file "$relative_file"; then
            log_message "File matches watch pattern, processing..."
            
            # Add a small delay to avoid rapid commits
            sleep 2
            
            # Re-parse config in case README was updated
            parse_config
            
            # Commit changes
            commit_changes "$file"
        else
            log_message "File doesn't match watch patterns, ignoring"
        fi
    done
}

# Handle script termination
cleanup() {
    log_message "Auto-Git Watcher stopped"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Run main function
main "$@"