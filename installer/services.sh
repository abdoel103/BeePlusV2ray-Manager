#!/usr/bin/env bash

install_services() {

    cp services/beeplus-websocket.service \
       /etc/systemd/system/

    systemctl daemon-reload

    systemctl enable beeplus-websocket

}
