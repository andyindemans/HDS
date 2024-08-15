#!/bin/bash

# Path to the .env file
ENV_FILE="../../.env"

# Load environment variables from the .env file
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo "Warning: .env file not found at $ENV_FILE"
fi


# Create the data directory if it doesn't exist
if [ ! -d "$DATA_DIR" ]; then
    echo "Directory $DATA_DIR does not exist. Creating it now..."
    sudo mkdir -p "$DATA_DIR"
    echo "Directory $DATA_DIR created."
else
    echo "Directory $DATA_DIR already exists."
fi

# Set the correct permissions
echo "Setting permissions for $DATA_DIR..."
sudo chmod -R 755 "$DATA_DIR"
sudo chown -R www-data:www-data "$DATA_DIR"
echo "Permissions set."


# Create the NextCloud directory if it doesn't exist
if [ ! -d "$NEXTCLOUD_DIR" ]; then
    echo "Directory $NEXTCLOUD_DIR does not exist. Creating it now..."
    sudo mkdir -p "$NEXTCLOUD_DIR"
    echo "Directory $NEXTCLOUD_DIR created."
else
    echo "Directory $NEXTCLOUD_DIR already exists."
fi

# Set the correct permissions
echo "Setting permissions for $NEXTCLOUD_DIR..."
sudo chmod -R 755 "$NEXTCLOUD_DIR"
sudo chown -R www-data:www-data "$NEXTCLOUD_DIR"
echo "Permissions set."

# Optional: Verify directory creation and permissions
ls -ld "$DATA_DIR"
ls -ld "$NEXTCLOUD_DIR"