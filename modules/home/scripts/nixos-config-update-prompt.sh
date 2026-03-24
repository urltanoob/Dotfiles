#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$HOME/nixos-config"
REMOTE_BRANCH="origin/main"
BACKUP_BASE_DIR="$HOME/nixos-config-backups"
BACKUP_KEEP_COUNT=5

cd "$REPO_DIR"

echo "Checking for nixos-config updates..."
git fetch origin main

LOCAL_HEAD="$(git rev-parse HEAD)"
REMOTE_HEAD="$(git rev-parse "$REMOTE_BRANCH")"
DIRTY="$(git status --porcelain)"

same_ref() { [[ "$LOCAL_HEAD" == "$REMOTE_HEAD" ]]; }
is_behind() { git merge-base --is-ancestor HEAD "$REMOTE_BRANCH"; }
is_ahead_only() { git merge-base --is-ancestor "$REMOTE_BRANCH" HEAD; }

commit_and_push() {
  local msg="$1"
  if [[ -z "${msg// /}" ]]; then
    echo "Commit message cannot be empty."
    return 1
  fi
  git add -A
  git commit -m "$msg"
  git push origin HEAD:main
}

prompt_commit_push() {
  echo
  echo "You have uncommitted changes. Commit everything and push to GitHub?"
  read -r -p "[y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Skipped commit/push."
    return 0
  fi
  local msg
  while true; do
    read -r -p "Commit message: " msg
    if [[ -n "${msg// /}" ]]; then
      break
    fi
    echo "Please enter a non-empty commit message."
  done
  commit_and_push "$msg"
  echo "Committed and pushed."
}

maybe_push_ahead() {
  local ahead
  ahead="$(git rev-list --count "$REMOTE_BRANCH"..HEAD)"
  if [[ "$ahead" -eq 0 ]]; then
    return 0
  fi
  echo
  echo "Local branch is $ahead commit(s) ahead of GitHub with no push yet."
  read -r -p "Push these commits to GitHub? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Push skipped."
    return 0
  fi
  git push origin HEAD:main
  echo "Push complete."
}

# Same commit as remote: only unpublished work is unstaged/uncommitted.
if same_ref; then
  if [[ -z "$DIRTY" ]]; then
    echo
    echo "nixos-config is already up to date."
    read -rp "Press Enter to close..."
    exit 0
  fi
  prompt_commit_push
  read -rp "Press Enter to close..."
  exit 0
fi

# Diverged: neither is ancestor of the other.
if ! is_behind && ! is_ahead_only; then
  echo
  echo "Local and $REMOTE_BRANCH have diverged (different histories)."
  echo "Resolve with git rebase, merge, or reset before pushing."
  read -rp "Press Enter to close..."
  exit 1
fi

# Strictly behind remote: offer to reset to match GitHub (existing behavior).
if is_behind && ! is_ahead_only; then
  echo
  echo "A newer version is available from GitHub."
  echo "Current: $LOCAL_HEAD"
  echo "Remote : $REMOTE_HEAD"
  echo
  echo "Overwrite your local repository with the remote version?"
  echo "This can discard local commits and uncommitted changes."
  read -r -p "[y/N]: " confirm

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo
    echo "Update canceled."
    read -rp "Press Enter to close..."
    exit 0
  fi

  timestamp="$(date +%Y%m%d-%H%M%S)"
  backup_dir="$BACKUP_BASE_DIR/nixos-config-$timestamp"

  echo
  echo "Creating backup at:"
  echo "  $backup_dir"
  mkdir -p "$BACKUP_BASE_DIR"
  cp -a "$REPO_DIR" "$backup_dir"
  echo "Backup complete."

  echo "Pruning old backups (keeping newest $BACKUP_KEEP_COUNT)..."
  mapfile -t backup_dirs < <(ls -1dt "$BACKUP_BASE_DIR"/nixos-config-* 2>/dev/null || true)
  if (( ${#backup_dirs[@]} > BACKUP_KEEP_COUNT )); then
    for old_backup in "${backup_dirs[@]:BACKUP_KEEP_COUNT}"; do
      rm -rf "$old_backup"
    done
  fi
  echo "Backup pruning complete."

  if [[ -n "$(git status --porcelain)" ]]; then
    echo
    echo "Uncommitted changes detected."
    echo "This will run:"
    echo "  git reset --hard $REMOTE_BRANCH"
    echo "  git clean -fd"
    read -r -p "Continue and overwrite everything? [y/N]: " confirm_dirty

    if [[ ! "$confirm_dirty" =~ ^[Yy]$ ]]; then
      echo
      echo "Update canceled."
      read -rp "Press Enter to close..."
      exit 0
    fi
  fi

  git reset --hard "$REMOTE_BRANCH"
  git clean -fd

  echo
  echo "Local nixos-config has been updated to $REMOTE_BRANCH."
  read -rp "Press Enter to close..."
  exit 0
fi

# Strictly ahead of remote (or could be ahead with extra dirty files).
echo
echo "Your local repo is ahead of GitHub (remote has no newer commits)."
if [[ -n "$DIRTY" ]]; then
  prompt_commit_push
else
  maybe_push_ahead
fi

read -rp "Press Enter to close..."
