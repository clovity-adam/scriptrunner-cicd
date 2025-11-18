// scripts/groovy/listeners/OnIssueUpdated.groovy
import com.atlassian.jira.event.issue.IssueEvent
import org.slf4j.LoggerFactory

// Named logger so we can easily enable it in Logging & profiling
def logger = LoggerFactory.getLogger("SRDEV.OnIssueUpdated")

// Get the event object from the binding
def ev = binding.getVariable("event") as IssueEvent
def key = ev.issue?.key
def who = ev.user?.displayName ?: "unknown"

// Read version marker written by the deploy pipeline (optional, but nice)
def versionTag = "no-version"
try {
    def versionFile = new File("/mnt/jira_shared/scripts/current/VERSION")
    if (versionFile.exists()) {
        versionTag = versionFile.text.trim()
    }
} catch (Exception ignored) {
    // If this fails, don't blow up the listener
}

// Log to file (via SRDEV logger) and to ScriptRunner’s listener log
logger.info("[SR-DEV ${versionTag}] Issue updated: ${key} by ${who}")
log.warn("[SR-DEV ${versionTag}] Issue updated: ${key} by ${who}")
