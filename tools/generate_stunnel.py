#!/usr/bin/env python3

import json
import os

CONFIG="/usr/local/beeplus/config/ssl.json"
OUTPUT="/etc/stunnel/stunnel.conf"

with open(CONFIG) as f:
    cfg=json.load(f)

ports=sorted(cfg.get("ports",[443]))
host=cfg.get("target_host","127.0.0.1")
target=cfg.get("target_port",22)

text="""foreground = no
debug = notice

cert = /etc/stunnel/stunnel.pem

socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

"""

for port in ports:
    text += f"""
[ssl-{port}]
client = no
accept = {port}
connect = {host}:{target}

"""

with open(OUTPUT,"w") as f:
    f.write(text)

print("stunnel.conf generated")
