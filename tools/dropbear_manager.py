#!/usr/bin/env python3

import json
import os
import signal
import subprocess
import time

CONFIG = "/usr/local/beeplus/config/dropbear.json"
PID_DIR = "/var/run/beeplus/dropbear"

os.makedirs(PID_DIR, exist_ok=True)


def load():
    with open(CONFIG) as f:
        return json.load(f)


def running():
    ports = {}

    for file in os.listdir(PID_DIR):
        if not file.endswith(".pid"):
            continue

        try:
            port = int(file[:-4])

            with open(os.path.join(PID_DIR, file)) as f:
                pid = int(f.read().strip())

            os.kill(pid, 0)
            ports[port] = pid

        except:
            try:
                os.remove(os.path.join(PID_DIR, file))
            except:
                pass

    return ports


def start(port):
    proc = subprocess.Popen(
        [
            "/usr/sbin/dropbear",
            "-F",
            "-p", str(port),
            "-W", "65536"
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

    with open(f"{PID_DIR}/{port}.pid", "w") as f:
        f.write(str(proc.pid))


def stop(port):
    file = f"{PID_DIR}/{port}.pid"

    if not os.path.exists(file):
        return

    try:
        with open(file) as f:
            pid = int(f.read().strip())

        os.kill(pid, signal.SIGTERM)

    except:
        pass

    try:
        os.remove(file)
    except:
        pass


while True:
    try:
        cfg = load()

        ports = cfg.get("ports", [110])

        # المنفذ 110 تديره خدمة dropbear الأصلية
        wanted = set(port for port in ports if port != 110)

        active = set(running().keys())

        for port in wanted - active:
            start(port)

        for port in active - wanted:
            stop(port)

    except:
        pass

    time.sleep(2)
