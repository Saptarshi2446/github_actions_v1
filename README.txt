
Zabbix Host Onboarding Automation

inventory/hosts.csv -> Device inventory
scripts/bulk_host_executor.py -> Reads CSV and executes host scripts
scripts/agent_host_add.py -> Adds agent hosts to Zabbix
scripts/snmpv*_host_add.py -> Adds SNMP hosts
agent_install/zabbix_agent_add.sh -> Installs Zabbix agent
.github/workflows/deploy.yml -> GitHub Actions pipeline

Update:
- ZABBIX_SERVER URL
- API TOKEN
- PEM key
