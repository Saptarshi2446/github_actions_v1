#!/bin/bash

sudo cat /etc/os-release
# sudo apt update
# sudo touch /etc/apt/sources.list.d/pgdg.list
# sudo chmod +x '/etc/apt/sources.list.d/pgdg.list'
# sudo ls -l '/etc/apt/sources.list.d/pgdg.list'
# sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# sleep 2
# sudo cat '/etc/apt/sources.list.d/pgdg.list'
# sudo wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
# sleep 2
# sudo apt-key add ACCC4CF8.asc
# sleep 2
# sudo apt update -y

sudo psql -V

# Update pg_hba.conf: replace peer/md5 with trust
sudo sed -i 's/peer/trust/g' /etc/postgresql/14/main/pg_hba.conf
sudo sed -i 's/md5/trust/g' /etc/postgresql/14/main/pg_hba.conf

# Allow all connections from all hosts (trust, insecure but fine for test)
echo "host    all    all    0.0.0.0/0    trust" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf
echo "host    all    all    ::/0         trust" | sudo tee -a /etc/postgresql/14/main/pg_hba.conf

# Allow Postgres to listen on all addresses
sudo sed -i "s/^#listen_addresses =.*/listen_addresses = '*'/g" /etc/postgresql/14/main/postgresql.conf

# Enable and restart services
sudo systemctl enable --now postgresql
sudo systemctl restart postgresql
sudo wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo apt update -y
sudo apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent apache2 -y
#
sudo su - postgres <<EOF
psql -c "alter user postgres with password 'password'"
createuser zabbixuser
psql -c "alter user zabbixuser with password 'zabbixpass'"
createuser zbx_monitor
psql -c "alter user zbx_monitor with password 'password'"
createdb zabbix_db -O zabbixuser
psql -c "grant all privileges on database zabbix_db to zabbixuser"
psql -c "grant pg_monitor to zbx_monitor"
EOF
sudo psql -U zabbixuser -w zabbix_db < /tmp/zabbix_demo.sql
#sudo zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | psql -U zabbixuser -w zabbix_db

#sed -i  "s/\.*#DBHost=localhost/DBHost=$host/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/DBName=.*/DBName=zabbix_db/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/DBUser=.*/DBUser=zabbixuser/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/.*DBPassword=.*/DBPassword=zabbixpass/" /etc/zabbix/zabbix_server.conf

sed -i 's/^Server=.*/Server=127.0.0.1/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^ServerActive=.*/ServerActive=127.0.0.1g' /etc/zabbix/zabbix_agentd.conf

sudo mkdir /var/lib/zabbix
# sudo cp /tmp/script/zabbix.conf.php /etc/zabbix/web/
# sudo chmod 600 /etc/zabbix/web/zabbix.conf.php
# sudo chown www-data:www-data /etc/zabbix/web/zabbix.conf.php

sudo zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | psql -U zabbixuser -w zabbix_db
sudo systemctl status zabbix-server
sudo systemctl start zabbix-server
sudo systemctl status zabbix-server
sudo systemctl enable zabbix-server
sudo systemctl status zabbix-server

sudo ip addr show
 #/etc/apache2/mods-available/status.conf
## monitor postgresql
# sudo cp -r /tmp/script/postgresql /var/lib/zabbix/
# sudo cp -r /tmp/script/template_db_postgresql.conf /etc/zabbix/zabbix_agentd.d/
# sudo chown -R zabbix:zabbix /var/lib/zabbix
# sudo chmod -R 755 /var/lib/zabbix

# ## install web service for reports
# sudo apt install -y zabbix-web-service
# sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt install -y ./google-chrome-stable_current_amd64.deb
# sudo apt install -y google-chrome-stable
# sudo sed -i 's/.*WebServiceURL=.*/WebServiceURL=http:\/\/10.0.10.165:10053\/report/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*StartReportWriters=.*/StartReportWriters=1/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/^AllowedIP=.*/AllowedIP=127.0.0.1,::1,10.0.10.165,10.0.10.167/g' /etc/zabbix/zabbix_web_service.conf
# sudo sed -i 's/.*NodeAddress=.*/NodeAddress=10.0.10.165:10051/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*HANodeName=.*/HANodeName=node1/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*StartPollers=.*/StartPollers=5/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*StartTrappers=.*/StartTrappers=5/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*JavaGateway=.*/JavaGateway=127.0.0.1/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*StartJavaPollers=.*/StartJavaPollers=5/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/^SNMPTrapperFile=.*/SNMPTrapperFile=/tmp/zabbix_traps.tmp/g' /etc/zabbix/zabbix_server.conf
# sudo sed -i 's/.*StartSNMPTrapper=.*/StartSNMPTrapper=1/g' /etc/zabbix/zabbix_server.conf
# sudo systemctl restart zabbix-server zabbix-agent postgresql apache2 zabbix-web-service

# ## create swapfile
# sudo dd if=/dev/zero of=/swapfile bs=128M count=8
# sudo chmod 600 /swapfile
# sudo mkswap /swapfile
# sudo swapon /swapfile 