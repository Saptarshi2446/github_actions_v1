#!/bin/bash

# Exit on error
set -e

# ====== CONFIGURATION ======
PEM_FILE="zbx_srv1.pem"       # Path to your PEM file
REMOTE_USER="ubuntu"          # Default EC2 username
REMOTE_IP="13.59.192.108"     # Target EC2 public IP
SCRIPT_LOCAL="zabbix_agent_add.sh" # Local script
SCRIPT_REMOTE="/home/ubuntu/zabbix_agent_add.sh"
# ============================

# Ensure PEM file has correct permissions
chmod 600 "$PEM_FILE"

echo "📦 Copying $SCRIPT_LOCAL to $REMOTE_USER@$REMOTE_IP ..."
sudo scp -i "$PEM_FILE" "$SCRIPT_LOCAL" "$REMOTE_USER@$REMOTE_IP:$SCRIPT_REMOTE"

echo "🚀 Executing script on $REMOTE_USER@$REMOTE_IP ..."
sudo ssh -i "$PEM_FILE" "$REMOTE_USER@$REMOTE_IP" "bash $SCRIPT_REMOTE"

echo "✅ Deployment complete."
