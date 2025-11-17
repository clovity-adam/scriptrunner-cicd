// current/groovy/listeners/OnIssueUpdated.groovy
import com.atlassian.jira.event.issue.IssueEvent
import org.slf4j.LoggerFactory

def logger = LoggerFactory.getLogger("SRDEV.OnIssueUpdated")   // easy to enable in Admin → Logging
def ev = binding.getVariable("event") as IssueEvent            // avoids 'event undeclared' checker warning

def key = ev.issue?.key
def who = ev.user?.displayName ?: "unknown"

logger.info("[SR-DEV] Issue updated: ${key} by ${who}")
