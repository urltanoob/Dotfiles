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

# Spinner while waiting for a background process
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

# Step wrapper with dynamic action/target
do_step() {
    local action="$1"     # e.g. "Installing"
    local target="$2"     # e.g. "hyprland"
    shift 2               # Shift away those two args

    # lowercase verb for OK/error message
    local lowercase_action
    lowercase_action=$(echo "$action" | tr '[:upper:]' '[:lower:]')

    log_info "$action $target..."
    if run "$@"; then
        log_ok "$target ${lowercase_action} successfully."
    else
        log_error "$target $lowercase_action failed."
        exit 1
    fi
}

# === Example Usage ===
do_step "Updating" "System" yay -Syu --noconfirm
do_step "Install" "NVIM" yay -S nvim --noconfirm
do_step "Removing" "NVIM" yay -Rcns neovim --noconfirm
