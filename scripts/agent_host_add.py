
import requests, json, sys

hostgroup = sys.argv[1]
template = sys.argv[2]
hostname = sys.argv[3]
ip = sys.argv[4]
port = sys.argv[5]

# === CONFIGURATION ===
ZABBIX_API_URL = "http://3.133.150.182/zabbix/api_jsonrpc.php"
USERNAME = "Admin"
PASSWORD = "zabbix"
# === AUTHENTICATE ===
auth_data = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "username": USERNAME,
        "password": PASSWORD
    },
    "id": 1
}

response = requests.post(ZABBIX_API_URL, json=auth_data, verify=False)
print(response)
auth_token = response.json()["result"]
print(auth_token)
HEADERS = {
    'Authorization': f'Bearer {auth_token}',
    'Content-Type': 'application/json-rpc'
}
print(HEADERS)

templates = [{"templateid": str(template_id).strip()} for template_id in str(template).split(";")]
groups = [{"groupid": str(group_id).strip()} for group_id in str(hostgroup).split(",")]
# Host creation payload
host_payload = {
    'jsonrpc': '2.0',
    'method': 'host.create',
    'params': {
        'host': hostname,  # Use the hostname as the hostname
        'interfaces': [
            {
                'type': 1,
                'main': 1,
                'useip': 1,
                'ip': ip,
                'dns': '',
                'port': port,
            }
        ],
        "groups": groups,
        "templates": templates
    },
    'id': 2,
}

# Add the host
response = requests.post(ZABBIX_API_URL, data=json.dumps(host_payload), headers=HEADERS)
host_result = response.json()
print(host_result)
if 'result' in host_result:
    host_id = host_result['result']['hostids'][0]
    print("Host added successfully. Host ID:", host_id)
else:
    print("Failed to add host.")

# Logout
logout_payload = {
    'jsonrpc': '2.0',
    'method': 'user.logout',
    'params': [],
    'id': 3,
    'auth': auth_token,
}

response = requests.post(ZABBIX_API_URL, data=json.dumps(logout_payload), headers=HEADERS)
print("Logged out.")
