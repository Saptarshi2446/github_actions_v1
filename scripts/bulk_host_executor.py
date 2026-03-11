
import pandas as pd
import subprocess
import sys

file_path = sys.argv[1]
#file_path = "inventory/hosts.csv"

print("Loading host file:", file_path)

if file_path.endswith(".csv"):
    df = pd.read_csv(file_path)
else:
    df = pd.read_excel(file_path)

print("Total hosts:", len(df))

for index, row in df.iterrows():

    selected_type = str(row[0])
    selected_hostgroup = str(row[1])
    selected_template = str(row[2])
    hostname = str(row[3])
    ip = str(row[4])
    port = str(row[5])
    snmp_type = str(row[6])
    snmp_port = str(row[7])
    securityname = str(row[8])
    community = str(row[9])

    command = []

    if selected_type == "1":

        command = [
            "python3",
            "scripts/agent_host_add.py",
            selected_hostgroup,
            selected_template,
            hostname,
            ip,
            port
        ]

    elif selected_type == "2" and snmp_type == "1":

        command = [
            "python3",
            "scripts/snmpv1_host_add.py",
            selected_hostgroup,
            selected_template,
            hostname,
            ip,
            snmp_port,
            community
        ]

    elif selected_type == "2" and snmp_type == "2":

        command = [
            "python3",
            "scripts/snmpv2_host_add.py",
            selected_hostgroup,
            selected_template,
            hostname,
            ip,
            snmp_port,
            community
        ]

    elif selected_type == "2" and snmp_type == "3":

        command = [
            "python3",
            "scripts/snmpv3_host_add.py",
            selected_hostgroup,
            selected_template,
            hostname,
            ip,
            snmp_port,
            securityname,
            community
        ]

    if command:
        print("Running:", " ".join(command))

        process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        stdout, stderr = process.communicate()

        print(stdout)

        if stderr:
            print(stderr)
