#!/bin/bash

# Load environment variables from .env file if it exists
ENV_FILE=".env"
[ -f "$ENV_FILE" ] && export $(grep -v '^#' "$ENV_FILE" | xargs) || echo "Warning: .env file not found at $ENV_FILE"

# Function to create a directory and set permissions
setup_nextcloud_dir() {
  local DIR_PATH=$1
  [ ! -d "$DIR_PATH" ] && sudo mkdir -p "$DIR_PATH" && echo "Directory $DIR_PATH created."
  sudo chmod -R 755 "$DIR_PATH"
  sudo chown -R www-data:www-data "$DIR_PATH"
  echo "Permissions set for $DIR_PATH"
}

# Setup NextCloud data and app directories
setup_nextcloud_dir "$NEXTCLOUD_DATA_DIR"
setup_nextcloud_dir "$NEXTCLOUD_APP_DIR"

# Optional: Verify directory creation and permissions
ls -ld "$NEXTCLOUD_DATA_DIR" "$NEXTCLOUD_APP_DIR"