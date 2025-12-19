#!/bin/bash

# Directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${SCRIPT_DIR}/.venv"
LOG_DIR="${SCRIPT_DIR}/logs"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Log file with rotation
LOG_FILE="${LOG_DIR}/run.log"

# Redirect all output to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Activate the virtual environment only if not in Docker
if [ -z "$DOCKER_CONTAINER" ]; then
    if [ ! -d "$VENV_DIR" ]; then
        echo "[$TIMESTAMP] Error: Virtual environment not found at $VENV_DIR"
        exit 1
    fi
    source "$VENV_DIR/bin/activate"
fi

# Check if script exists
if [ -z "$1" ] || [ ! -f "${SCRIPT_DIR}/$1" ]; then
    echo "[$TIMESTAMP] Error: Script not found: $1"
    exit 1
fi

SCRIPT_NAME="$1"
shift

# Run the script
echo "[$TIMESTAMP] Starting $SCRIPT_NAME..."
python "${SCRIPT_DIR}/${SCRIPT_NAME}" "$@"
EXIT_CODE=$?

echo "[$TIMESTAMP] Completed with exit code: $EXIT_CODE"

# Deactivate only if we activated it
if [ -z "$DOCKER_CONTAINER" ]; then
    deactivate
fi

exit $EXIT_CODE