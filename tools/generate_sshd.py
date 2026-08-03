#!/usr/bin/env python3

import json

CONFIG="/usr/local/beeplus/config/openssh.json"
SSHD="/etc/ssh/sshd_config"

with open(CONFIG) as f:
    cfg=json.load(f)

ports=sorted(cfg.get("ports",[22]))

with open(SSHD) as f:
    lines=f.readlines()

new=[]

for line in lines:
    s=line.strip()
    if s.startswith("Port ") or s=="#Port 22":
        continue
    new.append(line)

new.insert(0,"\n".join(f"Port {p}" for p in ports)+"\n\n")

with open(SSHD,"w") as f:
    f.writelines(new)

print("sshd_config updated.")
