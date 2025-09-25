import requests
import json
import sys

# Extract arguments from command-line
custom_text = sys.argv[2]
custom_IP = sys.argv[1]

url = "http://18.216.51.112:8080/api_jsonrpc.php"
username = "Zabbix"
password = "Nocteam@@456"

# API headers
headers = {'Content-Type': 'application/json'}

# Zabbix API authentication payload
auth_payload = {
    'jsonrpc': '2.0',
    'method': 'user.login',
    'params': {
        'user': username,
        'password': password,
    },
    'id': 1,
}

# Authenticate and get the authentication token
response = requests.post(url, data=json.dumps(auth_payload), headers=headers)
auth_result = response.json()

if 'result' in auth_result:
    auth_token = auth_result['result']
    print("Authentication successful. Auth token:", auth_token)
else:
    print("Authentication failed.")
    exit()

# Host creation payload
# Host creation payload
host_payload = {
    'jsonrpc': '2.0',
    'method': 'host.create',
    'params': {
        'host': custom_text,  # Use the custom_text as the hostname
        'interfaces': [
            {
                'type': 1,
                'main': 1,
                'useip': 1,
                'ip': custom_IP,
                'dns': '',
                'port': 10050,
            }
        ],
        "groups": [
            {
                "groupid": "115"
            }
        ],
        "templates": [
            {
                "templateid": "10001"
            }
        ],
    },
    'auth': auth_token,
    'id': 2,
}

# Add the host
response = requests.post(url, data=json.dumps(host_payload), headers=headers)
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

response = requests.post(url, data=json.dumps(logout_payload), headers=headers)
print("Logged out.")
