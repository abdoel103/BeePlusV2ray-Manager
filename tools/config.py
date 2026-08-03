#!/usr/bin/env python3

import json
import os
import sys

BASE_DIR="/usr/local/beeplus/config"

DEFAULT_PORTS={
    "openssh":22,
    "websocket":80,
    "ssl":443,
    "dropbear":110
}
def ensure(service):
    os.makedirs(BASE_DIR,exist_ok=True)

    path=os.path.join(BASE_DIR,f"{service}.json")

    if os.path.exists(path):
        return path

    default={
        "enabled":True,
        "target_host":"127.0.0.1",
        "target_port":22,
        "ports":[DEFAULT_PORTS.get(service,80)]
    }

    with open(path,"w") as f:
        json.dump(default,f,indent=4)

    return path


def load(service):
    with open(ensure(service)) as f:
        return json.load(f)


def save(service,data):
    with open(ensure(service),"w") as f:
        json.dump(data,f,indent=4)


def list_ports(service):
    data=load(service)
    for port in sorted(data["ports"]):
        print(port)


def add_port(service,port):
    data=load(service)

    port=int(port)

    if port not in data["ports"]:
        data["ports"].append(port)
        data["ports"].sort()

    save(service,data)


def remove_port(service,port):
    data=load(service)

    port=int(port)

    default_port=DEFAULT_PORTS.get(service,80)

    if port==default_port:
        print(f"Default port {default_port} cannot be removed.")
        return

    if port in data["ports"]:
        data["ports"].remove(port)

    save(service,data)


def enable(service):
    data=load(service)
    data["enabled"]=True
    save(service,data)


def disable(service):
    data=load(service)
    data["enabled"]=False
    save(service,data)


def usage():
    print("Usage:")
    print("config.py websocket list")
    print("config.py websocket add-port 2052")
    print("config.py websocket remove-port 2052")
    print("config.py ssl list")
    print("config.py ssl add-port 8443")
    print("config.py ssl remove-port 8443")


def main():

    if len(sys.argv)<3:
        usage()
        return

    service=sys.argv[1]
    command=sys.argv[2]

    if command=="list":
        list_ports(service)

    elif command=="add-port":
        add_port(service,sys.argv[3])

    elif command=="remove-port":
        remove_port(service,sys.argv[3])

    elif command=="enable":
        enable(service)

    elif command=="disable":
        disable(service)

    else:
        usage()


if __name__=="__main__":
    main()
