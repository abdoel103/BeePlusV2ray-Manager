#!/usr/bin/env python3

import re
import sys
import subprocess

WS_FILE = "/usr/local/beeplus/websocket/ws.py"


def read_ports():
    with open(WS_FILE, "r") as f:
        text = f.read()

    m = re.search(r"^PORTS\s*=\s*\[(.*?)\]", text, re.MULTILINE)
    if not m:
        print("PORTS line not found")
        sys.exit(1)

    ports = []

    for p in m.group(1).split(","):
        p = p.strip()
        if p:
            ports.append(int(p))

    return text, ports


def write_ports(text, ports):
    newline = "PORTS = [{}]".format(
        ", ".join(str(p) for p in ports)
    )

    text = re.sub(
        r"^PORTS\s*=\s*\[(.*?)\]",
        newline,
        text,
        flags=re.MULTILINE
    )

    with open(WS_FILE, "w") as f:
        f.write(text)


def restart():
    subprocess.run(
        ["systemctl", "restart", "beeplus-websocket"],
        check=False
    )


if len(sys.argv) < 2:
    print("Usage:")
    print("  ports.py list")
    print("  ports.py add PORT")
    print("  ports.py remove PORT")
    sys.exit(1)

cmd = sys.argv[1]

text, ports = read_ports()

if cmd == "list":

    for p in ports:
        print(p)

elif cmd == "add":

    if len(sys.argv) != 3:
        sys.exit(1)

    port = int(sys.argv[2])

    if port in ports:
        print("Port already exists")
        sys.exit(0)

    ports.append(port)
    ports.sort()

    write_ports(text, ports)
    restart()

    print("Added:", port)

elif cmd == "remove":

    if len(sys.argv) != 3:
        sys.exit(1)

    port = int(sys.argv[2])

    if port not in ports:
        print("Port not found")
        sys.exit(0)

    if len(ports) == 1:
        print("Cannot remove last port")
        sys.exit(1)

    ports.remove(port)

    write_ports(text, ports)
    restart()

    print("Removed:", port)

else:
    print("Unknown command")
