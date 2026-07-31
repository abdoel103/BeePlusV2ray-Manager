
#!/usr/bin/env python3

import json
import os
import sys

BASE_DIR = "/usr/local/beeplus/config"


def ensure(service):
    os.makedirs(BASE_DIR, exist_ok=True)

    path = os.path.join(BASE_DIR, f"{service}.json")

    if os.path.exists(path):
        return path

    default = {
        "enabled": True,
        "target_host": "127.0.0.1",
        "target_port": 22,
        "ports": [80]
    }

    with open(path, "w") as f:
        json.dump(default, f, indent=4)

    return path


def load(service):
    path = ensure(service)

    with open(path) as f:
        return json.load(f)


def save(service, data):
    path = ensure(service)

    with open(path, "w") as f:
        json.dump(data, f, indent=4)


def list_ports(service):
    data = load(service)

    for port in sorted(data["ports"]):
        print(port)


def add_port(service, port):
    data = load(service)

    port = int(port)

    if port not in data["ports"]:
        data["ports"].append(port)
        data["ports"].sort()

    save(service, data)


def remove_port(service, port):
    data = load(service)

    port = int(port)

    if port == 80:
        print("Default port cannot be removed.")
        return

    if port in data["ports"]:
        data["ports"].remove(port)

    save(service, data)


def enable(service):
    data = load(service)
    data["enabled"] = True
    save(service, data)


def disable(service):
    data = load(service)
    data["enabled"] = False
    save(service, data)


def usage():
    print("Usage:")
    print("config.py websocket list")
    print("config.py websocket add-port 2052")
    print("config.py websocket remove-port 2052")
    print("config.py websocket enable")
    print("config.py websocket disable")


def main():

    if len(sys.argv) < 3:
        usage()
        return

    service = sys.argv[1]
    command = sys.argv[2]

    if command == "list":
        list_ports(service)

    elif command == "add-port":
        add_port(service, sys.argv[3])

    elif command == "remove-port":
        remove_port(service, sys.argv[3])

    elif command == "enable":
        enable(service)

    elif command == "disable":
        disable(service)

    else:
        usage()


if __name__ == "__main__":
    main()
