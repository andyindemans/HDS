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

# Setup NextCloud data and app directories
setup_dir_with_permissions "$NEXTCLOUD_DATA_DIR" "www-data:www-data"
setup_dir_with_permissions "$NEXTCLOUD_APP_DIR" "www-data:www-data"

# Verify directory creation and permissions
ls -ld "$NEXTCLOUD_DATA_DIR" "$NEXTCLOUD_APP_DIR"


setup_generic_dir() {
  local DIR_PATH=$1
  [ ! -d "$DIR_PATH" ] && mkdir -p "$DIR_PATH" && echo "Directory $DIR_PATH created."
}

setup_generic_dir "$PAPERLESS_DATA_DIR"
setup_generic_dir "$PAPERLESS_MEDIA_DIR"

# Verify directory creation and permissions
ls -ld "$PAPERLESS_DATA_DIR" "$PAPERLESS_MEDIA_DIR"


setup_dir_with_permissions "$JELLYFIN_CACHE_DIR" "${APP_UID}:${APP_UID}"
setup_dir_with_permissions "$JELLYFIN_MEDIA_DIR" "${APP_UID}:${APP_UID}"

# Verify directory creation and permissions
ls -ld "$JELLYFIN_CACHE_DIR" "$JELLYFIN_MEDIA_DIR"


setup_dir_with_permissions "$FILEBROWSER_ROOT" "${APP_UID}:${APP_UID}"

# Verify directory creation and permissions
ls -ld "$FILEBROWSER_ROOT"