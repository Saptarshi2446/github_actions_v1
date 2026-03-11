
import requests, json, sys

hostgroup = sys.argv[1]
template = sys.argv[2]
hostname = sys.argv[3]
ip = sys.argv[4]
port = sys.argv[5]
extra = sys.argv[6]

ZABBIX_URL = "http://YOUR_ZABBIX_SERVER/api_jsonrpc.php"
TOKEN = "YOUR_API_TOKEN"

payload = {
 "jsonrpc": "2.0",
 "method": "host.create",
 "params": {
   "host": hostname,
   "interfaces": [{
     "type": 2,
     "main": 1,
     "useip": 1,
     "ip": ip,
     "dns": "",
     "port": port
   }],
   "groups": [{"groupid": hostgroup}],
   "templates": [{"templateid": template}]
 },
 "auth": TOKEN,
 "id": 1
}

headers = {"Content-Type": "application/json"}
response = requests.post(ZABBIX_URL, headers=headers, data=json.dumps(payload))
print(response.text)
