vim-jira-wrapper
================

Vim plugin wrapping [Ruby Gem JIRA CLI](https://github.com/ruby-jira/jira-cli).

The plugin provides the following command:

* `JiraIssue IssueId` - Open new vsplit with given Jira issue 
* `Jira your command` - Open new vsplit with output of Jira
  command, e.g.: `Jira issue jql assignee = "you" and status not in (Closed)`
