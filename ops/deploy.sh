#!/usr/bin/env bash
# ops/deploy.sh
#
# Required env:
#   SSH_HOST        # e.g. rhel-jira-02
#   SSH_USER        # e.g. root or a service account
#   SHARED_HOME     # e.g. /mnt/jira_shared
#
# Optional env:
#   RELEASE_VER     # defaults to timestamp if not set
#   PRUNE_KEEP      # default 10
#   SSH_OPTS        # e.g. '-o ProxyCommand="tailscale nc %h %p" -o StrictHostKeyChecking=accept-new'
#
set -euo pipefail

: "${SSH_HOST:?set SSH_HOST}"
: "${SSH_USER:?set SSH_USER}"
: "${SHARED_HOME:?set SHARED_HOME}"

RELEASE_VER="${RELEASE_VER:-$(date +'%Y.%m.%d_%H%M%S')}"
PRUNE_KEEP="${PRUNE_KEEP:-10}"

ART="release-${RELEASE_VER}.tar.gz"

echo "Creating artifact ${ART} from scripts/..."
tar -czf "${ART}" -C scripts .

REMOTE_TMP="${SHARED_HOME%/}/scripts/tmp-${RELEASE_VER}"
REMOTE_ART="${REMOTE_TMP}/${ART}"

SSH_CMD="ssh ${SSH_OPTS:-}"
SCP_CMD="scp ${SSH_OPTS:-}"

echo "Deploying ${ART} to ${SSH_USER}@${SSH_HOST} (tmp: ${REMOTE_TMP})"

# Stage artifact + apply script on remote host
${SSH_CMD} "${SSH_USER}@${SSH_HOST}" "mkdir -p '${REMOTE_TMP}'"
${SCP_CMD} "${ART}" "${SSH_USER}@${SSH_HOST}:${REMOTE_ART}"
${SCP_CMD} ops/apply.sh "${SSH_USER}@${SSH_HOST}:${REMOTE_TMP}/apply.sh"
${SSH_CMD} "${SSH_USER}@${SSH_HOST}" "chmod +x '${REMOTE_TMP}/apply.sh'"

# Apply on remote and clean up temp
${SSH_CMD} "${SSH_USER}@${SSH_HOST}" bash -lc "
  set -euo pipefail
  '${REMOTE_TMP}/apply.sh' '${REMOTE_ART}' '${SHARED_HOME}' '${RELEASE_VER}' '${PRUNE_KEEP}'
  rm -rf '${REMOTE_TMP}'
"

echo "Deployed ${RELEASE_VER} ✔"
