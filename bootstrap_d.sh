#!/bin/bash

# Color codes
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;34m"
NC="\033[0m"

# Logging functions
log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[ OK ]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Spinner while waiting for a background PID
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    tput civis
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "      \b\b\b\b\b\b"
    tput cnorm
}

# Run a command silently with spinner
run() {
    "$@" >/dev/null 2>&1 &
    local pid=$!
    spinner $pid
    wait $pid
    return $?
}

# Step wrapper with info, spinner, and result
do_step() {
    local description="$1"
    local success_msg="$2"
    shift 2

    log_info "$description"
    if run "$@"; then
        log_ok "$success_msg"
    else
        log_error "$description failed."
        exit 1
    fi
}

# === Example Usage ===
do_step "Updating package database..." "Package database updated." pacman -Syu
do_step "Installing base system..." "Base system installed." pacman -S --noconfirm base linux linux-firmware
