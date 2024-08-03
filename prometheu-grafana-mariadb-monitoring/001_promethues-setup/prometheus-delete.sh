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

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    error_exit "This script must be run as root"
fi

# Revert Prometheus systemd service
warning_message "Stopping Prometheus service..."
if sudo systemctl stop prometheus; then
    success_message "Prometheus service stopped successfully"
else
    error_exit "Failed to stop Prometheus service"
fi

warning_message "Removing Prometheus systemd service file..."
if ! sudo rm /etc/systemd/system/prometheus.service; then
    error_exit "Failed to remove Prometheus systemd service file"
fi
success_message "Prometheus systemd service file removed successfully"

warning_message "Reloading systemd daemon..."
if sudo systemctl daemon-reload; then
    success_message "Systemd daemon reloaded successfully"
else
    error_exit "Failed to reload systemd daemon"
fi

# Revert Prometheus configuration file
warning_message "Removing Prometheus configuration file..."
if ! sudo rm /etc/prometheus/prometheus.yml; then
    error_exit "Failed to remove Prometheus configuration file"
fi
success_message "Prometheus configuration file removed successfully"

# Revert Prometheus web consoles and libraries
warning_message "Removing Prometheus web consoles and libraries..."
if ! sudo rm -r /etc/prometheus/consoles /etc/prometheus/console_libraries; then
    error_exit "Failed to remove Prometheus web consoles and libraries"
fi
success_message "Prometheus web consoles and libraries removed successfully"

# Revert Prometheus binaries
warning_message "Removing Prometheus binaries..."
if ! sudo rm /usr/local/bin/prometheus /usr/local/bin/promtool; then
    error_exit "Failed to remove Prometheus binaries"
fi
success_message "Prometheus binaries removed successfully"

# Revert Prometheus archive extraction
warning_message "Removing Prometheus archive..."
if ! sudo rm -r prometheus-2.27.1.linux-amd64; then
    error_exit "Failed to remove Prometheus archive"
fi
success_message "Prometheus archive removed successfully"

# Revert Prometheus release download
warning_message "Removing Prometheus release..."
if ! sudo rm prometheus-2.27.1.linux-amd64.tar.gz; then
    error_exit "Failed to remove Prometheus release"
fi
success_message "Prometheus release removed successfully"

# Revert Prometheus directories creation
warning_message "Removing Prometheus directories..."
if ! sudo rm -r /etc/prometheus /var/lib/prometheus; then
    error_exit "Failed to remove Prometheus directories"
fi
success_message "Prometheus directories removed successfully"

# Revert Prometheus user creation
warning_message "Removing Prometheus user..."
if ! sudo userdel prometheus; then
    error_exit "Failed to remove Prometheus user"
fi
success_message "Prometheus user removed successfully"

success_message "Prometheus uninstallation reverted successfully"