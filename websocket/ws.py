import socket, threading, select

LISTENING_ADDR = '0.0.0.0'
PORTS = [80]
DEFAULT_HOST = '127.0.0.1:22'
RESPONSE = 'HTTP/1.1 101 Switching Protocols\r\n\r\n'
BUFLEN = 4096 * 4
TIMEOUT = 60

def handle(client, addr):
    try:
        data = client.recv(BUFLEN)
        client.sendall(RESPONSE.encode())
        target = socket.create_connection(DEFAULT_HOST.split(":"))
        client.setblocking(False)
        target.setblocking(False)
        while True:
            r, _, _ = select.select([client, target], [], [], 3)
            if client in r:
                data = client.recv(BUFLEN)
                if not data: break
                target.sendall(data)
            if target in r:
                data = target.recv(BUFLEN)
                if not data: break
                client.sendall(data)
    except: pass
    finally:
        client.close()
        try: target.close()
        except: pass

def start_server(port):
    try:
        server = socket.socket()
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind((LISTENING_ADDR, port))
        server.listen(100)
        print(f"[✓] Listening on port {port}")
        while True:
            client, addr = server.accept()
            threading.Thread(target=handle, args=(client, addr), daemon=True).start()
    except Exception as e:
        print(f"[✗] Failed to bind port {port}: {e}")

for port in PORTS:
    threading.Thread(target=start_server, args=(port,), daemon=True).start()

print("🔥 WebSocket servers started on 80, 8080, and 8880.")
import time
while True: time.sleep(60)
