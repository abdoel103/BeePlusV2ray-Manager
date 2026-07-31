#!/usr/bin/env python3

import socket
import threading
import select

CONFIG_FILE = "/etc/beeplusv2ray/websocket.conf"

LISTENING_ADDR = "0.0.0.0"
DEFAULT_HOST = ("127.0.0.1", 22)

RESPONSE = (
    "HTTP/1.1 101 Switching Protocols\r\n"
    "Connection: Upgrade\r\n"
    "Upgrade: websocket\r\n\r\n"
)

BUFFER = 16384


def load_ports():
    ports = []

    try:
        with open(CONFIG_FILE, "r") as f:
            for line in f:
                line = line.strip()

                if line.isdigit():
                    ports.append(int(line))

    except FileNotFoundError:
        ports = [80, 8080, 8880]

    return sorted(set(ports))


def handle(client):

    target = None

    try:

        client.recv(BUFFER)

        client.sendall(RESPONSE.encode())

        target = socket.create_connection(DEFAULT_HOST)

        client.setblocking(False)
        target.setblocking(False)

        while True:

            r, _, _ = select.select([client, target], [], [])

            if client in r:
                data = client.recv(BUFFER)

                if not data:
                    break

                target.sendall(data)

            if target in r:
                data = target.recv(BUFFER)

                if not data:
                    break

                client.sendall(data)

    except Exception:
        pass

    finally:

        client.close()

        if target:
            target.close()


def start_server(port):

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    server.bind((LISTENING_ADDR, port))

    server.listen(100)

    print(f"[+] WebSocket listening on {port}")

    while True:

        client, _ = server.accept()

        threading.Thread(
            target=handle,
            args=(client,),
            daemon=True
        ).start()


if __name__ == "__main__":

    ports = load_ports()

    print("Ports:", ports)

    for port in ports:

        threading.Thread(
            target=start_server,
            args=(port,),
            daemon=True
        ).start()

    threading.Event().wait()
