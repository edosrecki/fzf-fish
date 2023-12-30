function __fzf_git_stash
    function usage
        echo USAGE
        echo '  __fzf_git_stash --action <action> <stash>'
        echo ''
        echo FLAGS
        echo '  -a, --action (parse, drop, view)  Specify an action to perform on a stash'
        echo '  -h, --help                        Print this help message'
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
    set -f stash $argv[1]

    switch $action
        # Parse output from __fzf_git_stashes and return stash id
        case parse
            set -l id (string split -f1 ' ' $stash)

            echo $id
            # Drop stash
        case drop
            set -l id (__fzf_git_stash --action parse $stash)

            git stash drop "$id"
            # Show stash in preview window
        case view
            set -l id (__fzf_git_stash --action parse $stash)

            git stash show --patch --stat --color=always "$id" | __fzf_delta
        case '*'
            usage
            return 1
    end
end
