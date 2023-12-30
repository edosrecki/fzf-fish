function __fzf_gh_repo
    function usage
        echo USAGE
        echo '  __fzf_gh_repo --action <action> <repo>'
        echo ''
        echo FLAGS
        echo '  -a, --action (parse|clone|browse|view)  Specify an action to perform on a repository'
        echo '  -h, --help                                 Print this help message'
    end

    argparse h/help 'a/action=' -- $argv >/dev/null 2>&1; or set -f error true
    argparse --min-args 1 --max-args 1 -- $argv >/dev/null 2>&1; or set -f error true

    if set -q _flag_help
        usage
        return 0
    end

    if set -q error
        usage
        return 1
    end

    set -f action $_flag_action
    set -f repo $argv[1]

    switch $action
        # Parse output from __fzf_gh_repos and return repository full name
        case parse
            set -f arr (string match -gr '^([^ ]+) +([^ ]+)' $repo)

            echo (string join '/' $arr)
            # Clone a repository
        case clone
            set -f full_name (__fzf_gh_repo --action parse $repo)

            gh repo clone "$full_name"
            # Open a repository in the browser
        case browse
            set -f full_name (__fzf_gh_repo --action parse $repo)

            gh repo view --web "$full_name"
            # Print repository details
        case view
            set -f full_name (__fzf_gh_repo --action parse $repo)

            GH_FORCE_TTY=true gh repo view "$full_name"
        case '*'
            usage
            return 1
    end
end
