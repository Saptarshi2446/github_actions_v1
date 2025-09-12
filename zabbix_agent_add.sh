#!/bin/bash

# Exit on error
set -e

# Check if zabbix agent is installed
if command -v zabbix_agentd >/dev/null 2>&1; then
    echo "Zabbix agent already installed"
else
    echo "Installing Zabbix agent..."
    # Add repo
    wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu22.04_all.deb
    sudo dpkg -i zabbix-release_latest_7.4+ubuntu22.04_all.deb
    sudo apt update -y
    sudo apt install -y zabbix-agent
fi

# Configure agentd.conf safely
CONF="/etc/zabbix/zabbix_agentd.conf"

sudo sed -i 's/^Server=.*/Server=3.15.199.235/' $CONF
sudo sed -i 's/^ServerActive=.*/ServerActive=3.15.199.235/' $CONF
sudo sed -i '/^Hostname=/s/^/#/' $CONF
sudo sed -i 's/^ListenPort=.*/ListenPort=10050/' $CONF
sudo sed -i 's/^HostMetadata=.*/HostMetadata=linux_github_actions/' "$CONF"

# If no HostMetadata line exists, append it to the end
if ! sudo grep -q '^HostMetadata=' "$CONF"; then
  echo "HostMetadata=linux_github_actions" | sudo tee -a "$CONF" > /dev/null
fi


# Restart and enable service
sudo systemctl enable zabbix-agent
sudo systemctl restart zabbix-agent

echo "Zabbix agent installation and configuration complete."