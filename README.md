# Jira DC ScriptRunner CI/CD (Artifact + Symlink)

This repo manages Groovy scripts for ScriptRunner on Jira Data Center and deploys them to the Jira Shared Home using GitHub Actions.

## Shared Home layout (on Jira cluster)

We assume Shared Home is mounted at:

- `/mnt/jira_shared`

ScriptRunner automatically treats:

- `/mnt/jira_shared/scripts`

as a script root. Our pipeline maintains:

```text
/mnt/jira_shared/scripts/
  releases/
    <RELEASE_VER>/
      groovy/...
      VERSION
  current -> /mnt/jira_shared/scripts/releases/<RELEASE_VER>
