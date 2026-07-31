#!/usr/bin/env python3

import socket
import threading
import select
import json
import os


CONFIG_FILE = "/usr/local/beeplus/config/websocket.json"

LISTEN_ADDR = "0.0.0.0"

BUFFER = 16384

TARGET = ("127.0.0.1", 22)

RESPONSE = (
    "HTTP/1.1 101 Switching Protocols\r\n"
    "Connection: Upgrade\r\n"
    "Upgrade: websocket\r\n\r\n"
)


def load_config():

    if not os.path.exists(CONFIG_FILE):
        return {
            "enabled": True,
            "target_host": "127.0.0.1",
            "target_port": 22,
            "ports": [80]
        }

    with open(CONFIG_FILE) as f:
        return json.load(f)



def proxy(client):

    target = None

    try:

        client.recv(BUFFER)

        client.sendall(RESPONSE.encode())

        target = socket.create_connection(TARGET)

        client.setblocking(False)
        target.setblocking(False)


        while True:

            r, _, _ = select.select(
                [client, target],
                [],
                []
            )

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



def start(port):

    server = socket.socket(
        socket.AF_INET,
        socket.SOCK_STREAM
    )

    server.setsockopt(
        socket.SOL_SOCKET,
        socket.SO_REUSEADDR,
        1
    )

    try:

        server.bind(
            (LISTEN_ADDR, port)
        )

        server.listen(100)

        print(
            f"WebSocket running on {port}"
        )


    except OSError as e:

        print(
            f"Port {port} unavailable: {e}"
        )

        return


    while True:

        client, _ = server.accept()

        threading.Thread(
            target=proxy,
            args=(client,),
            daemon=True
        ).start()



def main():

    config = load_config()

    ports = config.get(
        "ports",
        [80]
    )


    print(
        "Active ports:",
        ports
    )


    for port in ports:

        threading.Thread(
            target=start,
            args=(port,),
            daemon=True
        ).start()


    threading.Event().wait()



if __name__ == "__main__":
    main()
