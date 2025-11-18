#!/usr/bin/env bash
# ops/apply.sh
# Usage: apply.sh <artifact.tar.gz> <shared_home> [release_ver] [prune_keep]
set -euo pipefail

ART="${1:?artifact path required}"
SHARED_HOME="${2:?shared home required}"      # e.g., /mnt/jira_shared
RELEASE_VER="${3:-$(date +'%Y.%m.%d_%H%M%S')}"
PRUNE_KEEP="${4:-10}"

BASE="${SHARED_HOME%/}/scripts"
REL_DIR="${BASE}/releases/${RELEASE_VER}"
CUR_LINK="${BASE}/current"

echo "Applying ${ART} to ${REL_DIR}"

mkdir -p "${REL_DIR}"

# Extract artifact contents into the release directory.
# The tar is created from the contents of scripts/, so no strip-components needed.
tar -xzf "${ART}" -C "${REL_DIR}"

# Sanity check: make sure the listener file exists
if [ ! -f "${REL_DIR}/groovy/listeners/OnIssueUpdated.groovy" ]; then
  echo "ERROR: Expected listener file not found in ${REL_DIR}"
  exit 1
fi

# Stamp version and flip symlink atomically
echo "${RELEASE_VER}" > "${REL_DIR}/VERSION"
ln -sfn "${REL_DIR}" "${CUR_LINK}"
echo "current -> $(readlink -f "${CUR_LINK}")"

# Prune older releases (keep newest N)
if [ -d "${BASE}/releases" ]; then
  cd "${BASE}/releases"
  # List by time, oldest first, drop all but latest PRUNE_KEEP
  ls -1tr | head -n -"${PRUNE_KEEP}" | xargs -r rm -rf --
fi

echo "Apply complete."
