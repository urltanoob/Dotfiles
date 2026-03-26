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
  echo "You have uncommitted changes:"
  git add -A
  git diff --stat --cached
  echo
  echo "Commit everything and push to GitHub?"
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
  show_changes "$REMOTE_BRANCH..HEAD"
  read -r -p "Push these commits to GitHub? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Push skipped."
    return 0
  fi
  git push origin HEAD:main
  echo "Push complete."
}

show_changes() {
  local range="$1"
  echo
  git log "$range" --oneline --stat
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
  ahead="$(git rev-list --count "$REMOTE_BRANCH"..HEAD)"
  behind="$(git rev-list --count "HEAD..$REMOTE_BRANCH")"
  echo "  Local is $ahead commit(s) ahead, $behind commit(s) behind."
  echo
  echo "--- Remote commits you don't have ---"
  show_changes "HEAD..$REMOTE_BRANCH"
  echo "--- Your local commits not on remote ---"
  show_changes "$REMOTE_BRANCH..HEAD"
  echo "Resolve with git rebase, merge, or reset before pushing."
  read -rp "Press Enter to close..."
  exit 1
fi

# Strictly behind remote: merge in remote changes, preserving uncommitted work.
if is_behind && ! is_ahead_only; then
  echo
  echo "A newer version is available from GitHub."
  echo "Current: $LOCAL_HEAD"
  echo "Remote : $REMOTE_HEAD"
  show_changes "HEAD..$REMOTE_BRANCH"
  echo
  echo "Merge remote changes into your local branch?"
  if [[ -n "$DIRTY" ]]; then
    echo "(Uncommitted changes will be stashed and restored after the merge.)"
  fi
  read -r -p "[y/N]: " confirm

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo
    echo "Update canceled."
    read -rp "Press Enter to close..."
    exit 0
  fi

  stashed=0
  if [[ -n "$DIRTY" ]]; then
    echo
    echo "Stashing uncommitted changes..."
    git stash push -u -m "nixos-config-update-prompt auto-stash"
    stashed=1
  fi

  echo
  echo "Merging $REMOTE_BRANCH..."
  if ! git merge --ff-only "$REMOTE_BRANCH"; then
    echo
    echo "Fast-forward not possible. Falling back to regular merge..."
    git merge "$REMOTE_BRANCH"
  fi

  if [[ "$stashed" -eq 1 ]]; then
    echo
    echo "Restoring stashed changes..."
    if ! git stash pop; then
      echo
      echo "WARNING: stash pop had conflicts. Your stashed changes are still in 'git stash list'."
      echo "Resolve conflicts manually, then run: git stash drop"
    else
      echo "Uncommitted changes restored."
    fi
  fi

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
