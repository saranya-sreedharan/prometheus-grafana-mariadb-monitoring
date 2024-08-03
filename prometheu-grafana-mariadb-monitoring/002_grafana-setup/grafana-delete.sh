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

# Stop and disable Grafana service
warning_message "Stopping and disabling Grafana service..."
if ! sudo systemctl stop grafana-server && sudo systemctl disable grafana-server; then
    error_exit "Failed to stop and disable Grafana service."
fi
success_message "Grafana service stopped and disabled successfully."

# Uninstall Grafana
warning_message "Uninstalling Grafana..."
if ! sudo apt-get remove -y grafana; then
    error_exit "Failed to uninstall Grafana."
fi
success_message "Grafana uninstalled successfully."

# Remove Grafana repository
grafana_repo="/etc/apt/sources.list.d/grafana.list"
warning_message "Removing Grafana repository (${grafana_repo})..."
if ! sudo rm -f "${grafana_repo}"; then
    error_exit "Failed to remove Grafana repository."
fi
success_message "Grafana repository removed successfully."

echo -e "${YELLOW}Revert completed successfully.${NC}"