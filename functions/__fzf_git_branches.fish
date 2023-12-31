function __fzf_git_branches
    function usage
        echo USAGE
        echo '  __fzf_git_branches [--toggle-all]'
        echo ''
        echo FLAGS
        echo '  --toggle-all  Toggle between local and all branches'
        echo '  -h, --help    Print this help message'
    end

    argparse h/help toggle-all -- $argv >/dev/null 2>&1; or set -f error true
    argparse --min-args 0 --max-args 0 -- $argv >/dev/null 2>&1; or set -f error true

    if set -q _flag_help
        usage
        return 0
    end

    if set -q error
        usage
        return 1
    end

    # Toggle local/all branches
    if set -q _flag_toggle_all
        set -U __fzf_git_branches_all (math "bitxor($__fzf_git_branches_all, 1)")
    end

    if test $__fzf_git_branches_all -eq 1
        set -f all --all
    end

    # Get branches
    set -l branches (git branch \
    $all \
    --sort=-committerdate \
    --sort=-HEAD \
    --color=always \
    --format='%(HEAD)'\t'%(refname:short)'\t'%(upstream:short)'\t'%(committerdate:relative)')

    # Format results
    set -fa result (set_color --bold white)'  Name'\t(set_color white)'Upstream'\t'Updated'(set_color normal)
    for branch in $branches
        set -f regex '^'(git remote | string join '|')
        set -f arr (string split \t $branch)
        set -f head $arr[1]
        set -f name $arr[2]
        set -f upstream $arr[3]
        set -f date $arr[4]

        if test $head = '*'
            set -f prefix ''
        else if string match -rq $regex $name
            set -f prefix ''
        else
            set -f prefix ' '
        end

        if test $upstream = ""
            set -f upstream $name
        end

        set -a result $prefix" $name"\t(set_color blue)$upstream\t$date(set_color normal)
    end

    printf "%s\n" $result | __fzf_column
end
