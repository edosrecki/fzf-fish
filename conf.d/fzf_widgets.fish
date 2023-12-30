status --is-interactive; or exit 0

## Initialize key bindings
## ~~~~~~~~~~~~~~~~~~~~~~~
fzf_cmd_key_bindings
fzf_git_key_bindings

## Configuration
## ~~~~~~~~~~~~~
# Widget popup width in percentage of the screen width
set __fzf_popup_width 80

# Array of PR states for GitHub PRs widget
set __fzf_gh_prs_states open all
# Array of limits when fetching results for GitHub PRs widget
set __fzf_gh_prs_limits 10 50 100 500 1000

# Array of organizations/users for GitHub repos widget
# Empty string ('') has a special meaning - repos for all organizations/users will be fetched
set __fzf_gh_repos_orgs ''
# Array of limits when fetching results for GitHub repos widget
set __fzf_gh_repos_limits 10 50 100 500 1000

# Optional
# set __fzf_column_cmd '/opt/homebrew/opt/util-linux/bin/column -m -c (__fzf_popup_columns) -t -s\t'
