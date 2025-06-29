#!/bin/bash

# Suppress initial echo by redirecting stdout/stderr
exec 3>&1 4>&2
exec >/dev/null 2>&1

# Color codes
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;34m"
NC="\033[0m"

# Logging functions (go to original stdout)
log_info()  { echo -e "${BLUE}[INFO]${NC} $1" >&3; }
log_ok()    { echo -e "${GREEN}[ OK ]${NC} $1" >&3; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&3; }

# Spinner while waiting for a background PID
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    tput civis
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr" >&3
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b" >&3
    done
    printf "      \b\b\b\b\b\b" >&3
    tput cnorm
}

# Run a command silently and log it, with spinner
run() {
    "$@" >>"$LOGFILE" 2>&1 &
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

# Log file setup
LOGFILE="/tmp/arch_bootstrap.log"
: > "$LOGFILE"

# === Example Usage ===
do_step "Updating package database..." "Package database updated." pacman -Sy
do_step "Installing base system..." "Base system installed." pacman -S --noconfirm base linux linux-firmware
do_step "Formatting root partition..." "Partition formatted." mkfs.ext4 /dev/sda1

# === Restore and dump log ===
exec 1>&3 2>&4
echo -e "\n${BLUE}[INFO]${NC} Dumping full log:"
cat "$LOGFILE"

