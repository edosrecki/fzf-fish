function __fzf_git_branch
    function usage
        echo USAGE
        echo '  __fzf_git_branch --action <action> <branch>'
        echo ''
        echo FLAGS
        echo '  -a, --action (parse|checkout|browse|view)  Specify an action to perform on a branch'
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
    set -f branch $argv[1]

    switch $action
        # Parse output from __fzf_git_branches and return branch name and remote name
        case parse
            set -f prefix (string sub -l 1 $branch)
            set -f full_name (echo $branch | string sub -s 3 | string split -f1 ' ')
            set -f regex '^('(git remote | string join '|')')/'

            # If it is a remote branch
            set -f name $full_name
            if test $prefix = ''
                set -f remote (string match -gr $regex $full_name)
                set name (string replace -r $regex '' $name)
            end

            echo $full_name
            echo $name
            echo $remote
            # Checkout a branch locally
        case checkout
            set -f parsed (__fzf_git_branch --action parse $branch)
            set -f name $parsed[2]

            git checkout $name
            # Open a branch in the browser
        case browse
            set -f parsed (__fzf_git_branch --action parse $branch)
            set -f name $parsed[2]
            set -f remote $parsed[3]
            if test -z $remote
                set -f remote origin
            end
            set -f url (git remote get-url $remote)

            if string match -rq '^git@' $url
                set -f url (string replace -r '\.git$' '' $url)
                set -f url (string replace -r ':' '/' $url)
                set -f url (string replace -r '^git@' 'https://' $url)
            end

            open "$url/tree/$name"
        case view
            set -f parsed (__fzf_git_branch --action parse $branch)
            set -f full_name $parsed[1]

            git log \
                --oneline \
                --graph \
                --date=short \
                --color=always \
                --pretty="format:%C(auto)%cd %h%d %s" \
                "$full_name"
        case '*'
            usage
            return 1
    end
end
