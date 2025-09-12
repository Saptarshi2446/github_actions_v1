#!/bin/bash
set -e

# ====== CONFIGURATION ======
PEM_FILE="zbx_srv1.pem"            # Path to your PEM file
REMOTE_USER="ubuntu"               # Default EC2 username
SCRIPT_LOCAL="zabbix_agent_add.sh" # Local script to copy & run
SCRIPT_REMOTE="/home/ubuntu/zabbix_agent_add.sh"
IP_FILE="targets.txt"              # File containing list of IPs (one per line)
# ============================

# Ensure PEM file has correct permissions
chmod 600 "$PEM_FILE"

# Check if targets file exists
if [ ! -f "$IP_FILE" ]; then
    echo "❌ ERROR: Target IP file $IP_FILE not found!"
    exit 1
fi

# Loop through IPs in file
while read -r REMOTE_IP; do
    REMOTE_IP=$(echo "$REMOTE_IP" | tr -d '\r' | xargs)   # strip CR and spaces

    # Skip blank lines and comments
    [[ -z "$REMOTE_IP" || "$REMOTE_IP" =~ ^# ]] && continue

    echo "📦 Copying $SCRIPT_LOCAL to $REMOTE_USER@$REMOTE_IP ..."
    scp -i "$PEM_FILE" "$SCRIPT_LOCAL" "$REMOTE_USER@$REMOTE_IP:$SCRIPT_REMOTE"

    echo "🚀 Executing script on $REMOTE_USER@$REMOTE_IP ..."
    ssh -i "$PEM_FILE" "$REMOTE_USER@$REMOTE_IP" "bash $SCRIPT_REMOTE"

    echo "✅ Done with $REMOTE_IP"
    echo "---------------------------------------------"
done < "$IP_FILE"


echo "🎉 Deployment completed for all targets!"
