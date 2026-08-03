#!/usr/bin/env python3

import json
import os
import signal
import subprocess

CONFIG="/usr/local/beeplus/config/dropbear.json"
PID_DIR="/var/run/beeplus-dropbear"

os.makedirs(PID_DIR, exist_ok=True)

with open(CONFIG) as f:
    cfg=json.load(f)

ports=sorted(cfg.get("ports",[110]))

primary=ports[0]

with open("/etc/default/dropbear","w") as f:
    f.write("NO_START=0\n")
    f.write(f"DROPBEAR_PORT={primary}\n")
    f.write("DROPBEAR_EXTRA_ARGS=\n")
    f.write('DROPBEAR_BANNER=""\n')
    f.write("DROPBEAR_RECEIVE_WINDOW=65536\n")

subprocess.run(
    ["systemctl","restart","dropbear"],
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL
)

for file in os.listdir(PID_DIR):
    if not file.endswith(".pid"):
        continue

    try:
        with open(os.path.join(PID_DIR,file)) as f:
            pid=int(f.read().strip())

        os.kill(pid, signal.SIGTERM)

    except:
        pass

    try:
        os.remove(os.path.join(PID_DIR,file))
    except:
        pass

for port in ports[1:]:

    proc=subprocess.Popen([
        "/usr/sbin/dropbear",
        "-F",
        "-E",
        "-p",str(port),
        "-W","65536"
    ])

    with open(f"{PID_DIR}/{port}.pid","w") as f:
        f.write(str(proc.pid))

print("Dropbear updated.")
