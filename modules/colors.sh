#!/usr/bin/env bash

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
WHITE="\e[97m"
RESET="\e[0m"

function info() {
    echo -e "${CYAN}$1${RESET}"
}

function success() {
    echo -e "${GREEN}$1${RESET}"
}

function error() {
    echo -e "${RED}$1${RESET}"
}

function warning() {
    echo -e "${YELLOW}$1${RESET}"
}
