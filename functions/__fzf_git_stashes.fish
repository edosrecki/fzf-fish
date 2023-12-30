function __fzf_git_stashes
    function usage
        echo USAGE
        echo '  __fzf_git_stashes'
        echo ''
        echo FLAGS
        echo '  -h, --help    Print this help message'
    end

    argparse h/help -- $argv >/dev/null 2>&1; or set -f error true
    argparse --min-args 0 --max-args 0 -- $argv >/dev/null 2>&1; or set -f error true

    if set -q _flag_help
        usage
        return 0
    end

    if set -q error
        usage
        return 1
    end

    # Get stashes
    set -l stashes (git stash list --format='%gd'\t'%s'\t'%ar')

    # Format results
    set -fa result (set_color --bold white)'Stash'\t'Description'\t(set_color white)'Created'(set_color normal)
    for stash in $stashes
        set -f arr (string split \t $stash)
        set -f id $arr[1]
        set -f description $arr[2]
        set -f date $arr[3]

        set -a result $id\t$description\t(set_color blue)$date(set_color normal)
    end

    printf "%s\n" $result | __fzf_column
end
