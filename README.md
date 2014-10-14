# JIRA Search Issues - Alfred workflow

This is a JIRA to search among your JIRA issues
and quickly open the JIRA's page in your browser.

**A lot faster than opening your JIRA Dashboard and
typing a search request!**

## Prerequisites

You need a JIRA user with credentials that may be used
to perform the API requests required by the workflow.

## How to install

```
git clone https://github.com/rchampourlier/alfred-workflow-jira-search-issues.git
cd alfred-workflow-jira-search-issues
bundle install
rake install # or rake dbxinstall if you're syncing Alfred using Dropbox
```

## Usage

You will have to create the `.jira-search-issues-config.yml`
file in your home directory to set the necessary settings
for this workflow to work.

## License

MIT
