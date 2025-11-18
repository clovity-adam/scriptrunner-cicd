// scripts/groovy/automation/AddInProgressComment.groovy
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.issue.Issue

// In ScriptRunner's Automation action, "issue" is in the binding
def Issue iss = binding.getVariable("issue") as Issue

def user = ComponentAccessor.jiraAuthenticationContext.loggedInUser
def commentManager = ComponentAccessor.commentManager

def msg = "SR demo: issue moved to In Progress at ${new Date()}"

// Add a comment
commentManager.create(iss, user, msg, false)

// Log for debugging
log.warn("[SR-DEV A4J] Added comment to ${iss.key}: ${msg}")
