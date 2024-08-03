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

# Prompt user for IP address and job name
read -p "Enter the IP address for the new job: " ip_address
read -p "Enter the job name: " job_name

# Validate IP address format
if ! [[ $ip_address =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error_exit "Invalid IP address format. Please enter a valid IP address."
fi

# Update Prometheus configuration file with the new job configuration
prometheus_config="/etc/prometheus/prometheus.yml"
job_config="  - job_name: '${job_name}'\n    static_configs:\n      - targets: ['${ip_address}:9104']"

warning_message "Adding new job configuration to Prometheus configuration file (${prometheus_config})..."
if sudo bash -c "echo -e '${job_config}' >> ${prometheus_config}"; then
    success_message "New job configuration added successfully."
else
    error_exit "Failed to add new job configuration."
fi

# Restart Prometheus
warning_message "Restarting Prometheus..."
if sudo systemctl restart prometheus; then
    success_message "Prometheus restarted successfully."
else
    error_exit "Failed to restart Prometheus."
fi

echo -e "${YELLOW}Update completed successfully.${NC}"
