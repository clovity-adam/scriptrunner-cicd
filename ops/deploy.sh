#!/usr/bin/env bash
set -euo pipefail

# Env: SSH_HOST, SSH_USER, SHARED_HOME=/mnt/jira_shared, SSH_OPTS (opt), RELEASE_VER (opt)

RELEASE_VER="${RELEASE_VER:-$(date +'%Y.%m.%d_%H%M%S')}"
REMOTE_BASE="${SHARED_HOME%/}/scripts"
REMOTE_RELEASE_DIR="${REMOTE_BASE}/releases/${RELEASE_VER}"
REMOTE_CURRENT_LINK="${REMOTE_BASE}/current"

ssh ${SSH_OPTS:-} "${SSH_USER}@${SSH_HOST}" "mkdir -p '${REMOTE_RELEASE_DIR}'"

rsync -avz -e "ssh ${SSH_OPTS:-}" scripts/ "${SSH_USER}@${SSH_HOST}":"${REMOTE_RELEASE_DIR}/"

ssh ${SSH_OPTS:-} "${SSH_USER}@${SSH_HOST}" bash -lc "
  set -euo pipefail
  test -f '${REMOTE_RELEASE_DIR}/groovy/listeners/OnIssueUpdated.groovy'
  ln -sfn '${REMOTE_RELEASE_DIR}' '${REMOTE_CURRENT_LINK}'
  echo 'current -> ' \$(readlink -f '${REMOTE_CURRENT_LINK}')
"

echo "Deployed ${RELEASE_VER} to ${SSH_HOST}:${REMOTE_RELEASE_DIR}"
