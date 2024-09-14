#!/bin/bash

# Load environment variables from .env file if it exists
ENV_FILE=".env"
[ -f "$ENV_FILE" ] && export $(grep -v '^#' "$ENV_FILE" | xargs) || echo "Warning: .env file not found at $ENV_FILE"

# Function to create a directory and set permissions
setup_dir_with_permissions() {
  local DIR_PATH=$1
  local USER_GROUP=$2

  [ ! -d "$DIR_PATH" ] && sudo mkdir -p "$DIR_PATH" && echo "Directory $DIR_PATH created."
  sudo chmod -R 755 "$DIR_PATH"
  sudo chown -R "$USER_GROUP" "$DIR_PATH"
  echo "Permissions set for $DIR_PATH with ownership $USER_GROUP"
}

# List of directories and their respective ownerships
declare -A DIRS=(
  ["$NEXTCLOUD_DATA_DIR"]="www-data:www-data"
  ["$NEXTCLOUD_APP_DIR"]="www-data:www-data"
  ["$PAPERLESS_DATA_DIR"]="${APP_UID}:${APP_UID}"
  ["$PAPERLESS_MEDIA_DIR"]="${APP_UID}:${APP_UID}"
  ["$JELLYFIN_CACHE_DIR"]="${APP_UID}:${APP_UID}"
  ["$JELLYFIN_MEDIA_DIR"]="${APP_UID}:${APP_UID}"
  ["$FILEBROWSER_ROOT"]="${APP_UID}:${APP_UID}"
  ["$FILEBROWSER_DATA_DIR"]="${APP_UID}:${APP_UID}"
)

# Loop through directories and set them up
for DIR in "${!DIRS[@]}"; do
  setup_dir_with_permissions "$DIR" "${DIRS[$DIR]}"
done

# Verify directory creation and permissions
ls -ld "${!DIRS[@]}"