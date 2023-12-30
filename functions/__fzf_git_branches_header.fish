function __fzf_git_branches_header
    set -f header

    # Branches type
    if test $__fzf_git_branches_all -eq 1
        set -f branches (set_color brblack)'Local,'(set_color --bold --dim white)'All'(set_color normal)(set_color brblack)
    else
        set -f branches (set_color --bold --dim white)'Local'(set_color normal)(set_color brblack)',All'
    end
    set -a header (set_color brblack)"Branches: $branches"

    __fzf_header $header
end
