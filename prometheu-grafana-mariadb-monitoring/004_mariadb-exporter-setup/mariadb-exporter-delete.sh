#!/bin/bash

# Color variables
RED='\033[0;31m'   # Red colored text
NC='\033[0m'       # Normal text
YELLOW='\033[33m'  # Yellow Color
GREEN='\033[32m'   # Green Color

# Function for error handling
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Function for success message
success_message() {
    echo -e "${GREEN}$1${NC}"
}

# Function for warning message
warning_message() {
    echo -e "${YELLOW}$1${NC}"
}

# Stop and remove Docker containers if they exist
warning_message "Stopping and removing Docker containers..."
if sudo docker-compose down &>/dev/null; then
    success_message "Docker containers stopped and removed successfully."
else
    warning_message "No Docker containers to remove."
fi

# Remove mysqld_exporter configuration file if it exists
warning_message "Removing mysqld_exporter configuration file..."
if sudo rm -f /home/ubuntu/mysqld_exporter.yml &>/dev/null; then
    success_message "mysqld_exporter configuration file removed successfully."
else
    warning_message "No mysqld_exporter configuration file to remove."
fi

# Remove mysqld_exporter Docker container if it exists
warning_message "Removing mysqld_exporter Docker container..."
if sudo docker rm -f $(sudo docker ps -a -q -f "ancestor=prom/mysqld-exporter") &>/dev/null; then
    success_message "mysqld_exporter Docker container removed successfully."
else
    warning_message "No mysqld_exporter Docker container to remove."
fi

# Remove Docker volumes if they exist
warning_message "Removing Docker volumes..."
if sudo rm -rf /var/lib/docker/volumes/mariadb_data &>/dev/null; then
    success_message "Docker volumes removed successfully."
else
    warning_message "No Docker volumes to remove."
fi

# Remove Docker and Docker Compose if they exist
warning_message "Removing Docker and Docker Compose..."
if sudo apt purge -y docker.io docker-compose &>/dev/null; then
    success_message "Docker and Docker Compose removed successfully."
else
    warning_message "No Docker or Docker Compose to remove."
fi

echo -e "${YELLOW}Revert operation completed successfully.${NC}"