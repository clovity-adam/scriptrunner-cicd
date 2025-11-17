import com.atlassian.jira.event.issue.IssueEvent

def ev  = event as IssueEvent
def key = ev.issue?.key
def who = ev.user?.displayName ?: "unknown"

log.info("[SR-DEV] Issue updated: ${key} by ${who}")
