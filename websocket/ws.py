#!/usr/bin/env python3

import socket
import threading
import select
import json
import time

LISTENING_ADDR = "0.0.0.0"
CONFIG = "/usr/local/beeplus/config/websocket.json"
RESPONSE = "HTTP/1.1 101 Switching Protocols\r\n\r\n"
BUFLEN = 4096 * 4
TIMEOUT = 60

try:
    with open(CONFIG) as f:
        cfg = json.load(f)

    PORTS = cfg.get("ports", [80])
    HOST = cfg.get("target_host", "127.0.0.1")
    TARGET_PORT = cfg.get("target_port", 22)
    DEFAULT_HOST = f"{HOST}:{TARGET_PORT}"

except Exception:
    PORTS = [80]
    DEFAULT_HOST = "127.0.0.1:22"


def handle(client, addr):
    try:
        client.recv(BUFLEN)
        client.sendall(RESPONSE.encode())

        target = socket.create_connection(DEFAULT_HOST.split(":"))

        client.setblocking(False)
        target.setblocking(False)

        while True:
            r, _, _ = select.select([client, target], [], [], 3)

            if client in r:
                data = client.recv(BUFLEN)
                if not data:
                    break
                target.sendall(data)

            if target in r:
                data = target.recv(BUFLEN)
                if not data:
                    break
                client.sendall(data)

    except:
        pass

    finally:
        try:
            client.close()
        except:
            pass

        try:
            target.close()
        except:
            pass


def start_server(port):
    try:
        server = socket.socket()
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind((LISTENING_ADDR, port))
        server.listen(100)

        print(f"[✓] Listening on port {port}")

        while True:
            client, addr = server.accept()
            threading.Thread(
                target=handle,
                args=(client, addr),
                daemon=True
            ).start()

    except Exception as e:
        print(f"[✗] Failed to bind port {port}: {e}")


for port in PORTS:
    threading.Thread(
        target=start_server,
        args=(port,),
        daemon=True
    ).start()

print(f"🔥 WebSocket servers started on ports: {', '.join(map(str, PORTS))}")

while True:
    time.sleep(60)
