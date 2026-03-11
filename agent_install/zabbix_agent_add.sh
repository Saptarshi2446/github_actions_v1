
#!/bin/bash
echo "Installing Zabbix agent"
sudo apt update
sudo apt install zabbix-agent -y
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent
echo "Agent installed successfully"
