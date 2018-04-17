#!/usr/bin/env python

import json
import re
import subprocess


# assume that we don't need to anaylyse input args since we return all the information on the first call with --list parameter.
# create dynamic inventory template
dyn_inventory = json.loads('{"app": { "children" : [] }, "db": { "children" : [] }, "_meta": {"hostvars": {} }}')

# request names and external IP addresses of the GCP compute instances in JSON format
json_string=subprocess.Popen('gcloud compute instances list --format="json(name, networkInterfaces[0].accessConfigs[0].natIP)"', shell=True, stdout=subprocess.PIPE).stdout.read()

parsed_json = json.loads(json_string)

# iterate over existing coumpute instances and populate JSON template with existing reources
for host in parsed_json:
	dyn_inventory[host["name"]]= []
	dyn_inventory[host["name"]].append(host["networkInterfaces"][0]["accessConfigs"][0]["natIP"])

	# depending on the name instance should be added into appor db group
	if re.match("^reddit-app", host["name"] ) is not None:
		dyn_inventory["app"]["children"].append(host["name"])

	if re.match("^reddit-db", host["name"] ) is not None:
		dyn_inventory["db"]["children"].append(host["name"])


# Output dynamic inventory
print json.dumps(dyn_inventory)
