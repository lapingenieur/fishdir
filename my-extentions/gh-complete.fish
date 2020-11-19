### HOMEMADE GH (GitHub CLi) commandline completion

### How is the command built ?
#
# * 'complete' is a fish internal command
#   * the '-f' flag means there's no file name in the completion list
#   * the '-c' flag gets the command name ( >> command <<, not argument), for us will always be '-c gh'
#   * the '-n' flag is a command executed each time ; if exits with 0 status then the following completions are listed (else not)
#     * 'test' just tests if an operation is true. Here it tells if the output of :
#       * 'commandline' sets/gets infos about the current command line on the prompt
#         * the '-o' flag gives each argument preceded by the command name ONE PER LINE (space = back to line)
#       * '|' (aka pipe) sends the output to folowing command's standard input
#       * 'tail' prints the end of what is given to it
#         * the '-n' flag sets the number of line to print (1 = print last received line)
#     equals ('=') the following word (by example : "gh")
#   * the '-a' flag specifies a list of possible arguments separated by a space
#   This action can be repeated if needs several checks
# We do that for each command (and "sub-command" of github cli) we want to autocomplete

# There's also a function for GH / help part further down in the file

function pnlr
# pnrl - Print Nth Last Line
	tail -n$argv | head -n1
end
function pnfr
# pnrl - Print Nth First Line
	head -n$argv | tail -n1
end

function tio
# tio - Test If Options are on the prompt
# 1st argument must be a number (for prompt nth argument)
# 2nd argument must be a list of arguments to eliminate if found (separated by pipes "|")
	if echo (commandline -o | pnfr $argv[1]) | egrep -q "$argv[2]"
		return 1
	else
		return 0
	end
end

# GH / --help option
# always allow --help argument if command line isn't starting by 'gh help' and if 
function gh_opthelp
	if test (commandline -o | pnfr 2) = help
		if test (commandline -o | wc -l) -lt 3
			return 0
		else
			if test (commandline -o | wc -l) = 3 && commandline -o | pnlr 1 | egrep -q '^-'
				return 0
			else
				return 1
			end
		end
	else 
		return 0
	end
end
complete -f -c gh -n "gh_opthelp" -a "--help" -d "Show help"

# GH
set -l gh_args 'alias|api|auth|completion|config|gist|help|issue|pr|release|repo|--version'
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a --version	-d "Show current gh version"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a alias	-d "Create command shortcuts"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a api		-d "Make an authenticated GitHub API request"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a auth		-d "Login, logout, and refresh your authentication"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a completion	-d "Generate shell completion scripts"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a config	-d "Manage configuration for gh"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a gist		-d "Manage gists"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a help		-d "Help about any command"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a issue	-d "Manage issues"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a pr		-d "Manage pull requests"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'" 		-a release	-d "Manage GitHub releases"
complete -f -c gh -n "test (commandline -o | pnlr 2) = gh && tio 2 '$gh_args'"		-a repo		-d "Create, clone, fork, and view repositories"

# GH / alias
set -l gh_alias_args 'delete|list|set'
complete -f -c gh -n "test (commandline -o | pnfr 2) = alias && tio 3 '$gh_alias_args'"	-a delete	-d "Delete an alias"
complete -f -c gh -n "test (commandline -o | pnfr 2) = alias && tio 3 '$gh_alias_args'"	-a list		-d "List your aliases"
complete -f -c gh -n "test (commandline -o | pnfr 2) = alias && tio 3 '$gh_alias_args'"	-a set		-d "Create a shortcut for a gh command"
complete -f -c gh -n "test (commandline -o | pnfr 2) = alias && test (commandline -o | pnfr 3) = set" -a -s -d "Declare an alias to be passed through a shell interpreter"
complete -f -c gh -n "test (commandline -o | pnfr 2) = alias && test (commandline -o | pnfr 3) = set" -a --shell -d "Declare an alias to be passed through a shell interpreter"

# GH / api
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a -F		-d "Add a parameter of inferred type"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --field		-d "Add a parameter of inferred type"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a -H		-d "Add an additional HTTP request header"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --header		-d "Add an additional HTTP request header"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a -i		-d "Include HTTP response headers in the output"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --include	-d "Include HTTP response headers in the output"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a -X		-d 'The HTTP method for the request (default "GET")'
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --method		-d 'The HTTP method for the request (default "GET")'
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a -f		-d "Add a string parameter"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --raw-field	-d "Add a string parameter"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --hostname	-d 'The GitHub hostname for the request (default "github.com")'
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --input		-d "The file to use as body for the HTTP request"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --paginate	-d "Make additional HTTP requests to fetch all pages of results"
complete -f -c gh -n "test (commandline -o | pnfr 2) = api" -a --silent		-d "Do not print the response body"

# GH / auth
set -l gh_auth_args 'login|logout|refresh|status'
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && tio 3 '$gh_auth_args'"	-a login	-d "Authenticate with a GitHub host"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && tio 3 '$gh_auth_args'"	-a logout	-d "Log out of a GitHub host"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && tio 3 '$gh_auth_args'"	-a refresh	-d "Refresh stored authentication credentials"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && tio 3 '$gh_auth_args'"	-a status	-d "View authentication status"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a -h		-d "The hostname of the GitHub instance to authenticate with"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a --hostname	-d "The hostname of the GitHub instance to authenticate with"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a -s		-d "Additional authentication scopes for gh to have"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a --scopes	-d "Additional authentication scopes for gh to have"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a -w		-d "Open a browser to authenticate"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a -web	-d "Open a browser to authenticate"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = login"	 -a --with-token -d "Read token from standard input"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = logout"	 -a -h		-d "The hostname of the GitHub instance to log out of"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = logout"	 -a --hostname	-d "The hostname of the GitHub instance to log out of"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = refresh" -a -h		-d "The GitHub host to use for authentication"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = refresh" -a --hostname	-d "The GitHub host to use for authentication"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = refresh" -a -s		-d "Additional authentication scopes for gh to have"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = refresh" -a --scopes	-d "Additional authentication scopes for gh to have"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = status"	 -a -h		-d "Check a specific hostname's auth status"
complete -f -c gh -n "test (commandline -o | pnfr 2) = auth && test (commandline -o | pnfr 3) = status"	 -a --hostname	-d "Check a specific hostname's auth status"

# GH / completion
complete -f -c gh -n "test (commandline -o | pnfr 2) = completion" -a -s		-d 'Shell type: {bash|zsh|fish|powershell}'
complete -f -c gh -n "test (commandline -o | pnfr 2) = completion" -a --shell	-d 'Shell type: {bash|zsh|fish|powershell}'

# GH / config
set -l gh_config_args 'set|get'
complete -f -c gh -n "test (commandline -o | pnfr 2) = config && tio 3 '$gh_config_args'" -a get -d "Print the value of a given configuration key"
complete -f -c gh -n "test (commandline -o | pnfr 2) = config && tio 3 '$gh_config_args'" -a set -d "Update configuration with a value for the given key"
complete -f -c gh -n "test (commandline -o | pnfr 2) = config && test (commandline -o | pnfr 3) = get" -a -h	 -d "Get per-host setting"
complete -f -c gh -n "test (commandline -o | pnfr 2) = config && test (commandline -o | pnfr 3) = get" -a --host -d "Get per-host setting"
complete -f -c gh -n "test (commandline -o | pnfr 2) = config && test (commandline -o | pnfr 3) = set" -a -h	 -d "Set per-host setting"
complete -f -c gh -n "test (commandline -o | pnfr 2) = config && test (commandline -o | pnfr 3) = set" -a --host -d "Set per-host setting"

# GH / gist
set -l gh_gist_args 'create|edit|list|view'
complete -f -c gh -n "test (commandline -o | pnfr 2) = gist && tio 3 '$gh_gist_args'" -a create	-d "Create a new gist"
complete -f -c gh -n "test (commandline -o | pnfr 2) = gist && tio 3 '$gh_gist_args'" -a edit	-d "Edit one of your gists"
complete -f -c gh -n "test (commandline -o | pnfr 2) = gist && tio 3 '$gh_gist_args'" -a list	-d "List your gists"
complete -f -c gh -n "test (commandline -o | pnfr 2) = gist && tio 3 '$gh_gist_args'" -a view	-d "View a gist"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = create"	-a -d		-d "A description for this gist"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = create"	-a --desc	-d "A description for this gist"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = create"	-a -f		-d "Provide a filename to be used when reading from STDIN"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = create"	-a --filename	-d "Provide a filename to be used when reading from STDIN"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = create"	-a -p		-d "List the gist publicly (default: private)"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = create"	-a --public	-d "List the gist publicly (default: private)"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = edit"	-a -f		-d "A specific file to edit"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = edit"	-a --filename	-d "A specific file to edit"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = list"	-a -L		-d "Maximum number of gists to fetch (default 10)"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = list"	-a --limit	-d "Maximum number of gists to fetch (default 10)"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = list"	-a --public	-d "Show only public gists"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = list"	-a --secret	-d "Show only secret gists"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = view"	-a -f		-d "Display a single file of the gist"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = view"	-a --filename	-d "Display a single file of the gist"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = view"	-a -r		-d "Do not try and render markdown"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = view"	-a --raw	-d "Do not try and render markdown"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = view"	-a -w		-d "Open gist in browser"
complete    -c gh -n "test (commandline -o | pnfr 2) = gist && test (commandline -o | pnfr 3) = view"	-a --web	-d "Open gist in browser"

# GH / help
function gh_nothelp
	if commandline -o | sed -z 's/\n/%/g' | egrep -q '^gh%help%help'
		return 1
	else
		return 0
	end
end

set -l gh_help_args 'alias|api|auth|completion|config|gist|issue|pr|release|repo|environment'
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a environment	-d "Environment variables that can be used with gh"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a alias		-d "Create command shortcuts"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a api		-d "Make an authenticated GitHub API request"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a auth		-d "Login, logout, and refresh your authentication"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a completion	-d "Generate shell completion scripts"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a config		-d "Manage configuration for gh"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a gist		-d "Manage gists"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a help		-d "Help about any command"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a issue		-d "Manage issues"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a pr		-d "Manage pull requests"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a release		-d "Manage GitHub releases"
complete -f -c gh -n "test (commandline -o | pnfr 2) = help && tio 3 '$gh_help_args' && gh_nothelp" -a repo		-d "Create, clone, fork, and view repositories"

# GH / issue
#the [HOST/]OWNER/REPO format
#the [HOST/]OWNER/REPO format
set -l gh_issue_args 'close|create|list|reopen|status|view'
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue" -a -r	-d "Select another repository using the [HOST/]OWNER/REPO format"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue" -a --repo	-d "Select another repository using the [HOST/]OWNER/REPO format"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && tio 3 '$gh_issue_args'" -a close	-d "Close issue"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && tio 3 '$gh_issue_args'" -a create	-d "Create issue"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && tio 3 '$gh_issue_args'" -a list		-d "List and filter issues in this repository"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && tio 3 '$gh_issue_args'" -a reopen	-d "Reopen issue"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && tio 3 '$gh_issue_args'" -a status	-d "Show status of relevant issues"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && tio 3 '$gh_issue_args'" -a view		-d "View an issue"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -a		-d "Assign people by their login"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a --assign	-d "Assign people by their login"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -b		-d "Supply a body. Will prompt for one otherwise."
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a --body	-d "Supply a body. Will prompt for one otherwise."
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -l		-d "Add labels by name"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a --label	-d "Add labels by name"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -m		-d "Add the issue to a milestone by name"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a --milestone	-d "Add the issue to a milestone by name"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -p		-d "Add the issue to projects by name"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a --project	-d "Add the issue to projects by name"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -t		-d "Supply a title. Will prompt for one otherwise."
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a --title	-d "Supply a title. Will prompt for one otherwise."
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = create" -a -w		-d "Open the browser to create an issue"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -a		-d "Filter by assignee"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --assignee	-d "Filter by assignee"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -A		-d "Filter by author"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --author	-d "Filter by author"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -l		-d "Filter by labels"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --label	-d "Filter by labels"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -l		-d "Maximum number of issues to fetch (default 30)"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --limit	-d "Maximum number of issues to fetch (default 30)"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --mention	-d "Filter by mention"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -m		-d 'Filter by milestone number or `title`'
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --milestone	-d 'Filter by milestone number or `title`'
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -s		-d 'Filter by state: {open|closed|all} (default "open")'
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --state	-d 'Filter by state: {open|closed|all} (default "open")'
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a -w		-d "Open the browser to list the issue(s)"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = list" -a --web		-d "Open the browser to list the issue(s)"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = view" -a -w		-d "Open the browser to list the issue(s)"
complete -f -c gh -n "test (commandline -o | pnfr 2) = issue && test (commandline -o | pnfr 3) = view" -a --web		-d "Open the browser to list the issue(s)"
