function __fzf_git_branches_header
    function usage
        echo USAGE
        echo '  __fzf_git_branches_header [--toggle-help]'
        echo ''
        echo FLAGS
        echo '  --toggle-help  Toggle between showing/hiding help message in header'
        echo '  -h, --help     Print this help message'
    end

    argparse h/help toggle-help -- $argv >/dev/null 2>&1; or set -f error true

    if set -q _flag_help
        usage
        return 0
    end

    if set -q error
        usage
        return 1
    end

    # Toggle help message
    if set -q _flag_toggle_help
        set -q __fzf_git_branches_help; or set -U __fzf_git_branches_help 0
        set -U __fzf_git_branches_help (math "bitxor($__fzf_git_branches_help, 1)")
    end

    # Branches type
    if test $__fzf_git_branches_all -eq 1
        set -f branches (set_color brblack)'Local,'(set_color --bold --dim white)'All'(set_color normal)(set_color brblack)
    else
        set -f branches (set_color --bold --dim white)'Local'(set_color normal)(set_color brblack)',All'
    end
    set -fa header (set_color brblack)"Branches: $branches"

    # Help
    if test $__fzf_git_branches_help -eq 1
        set -fa help (set_color --italics --bold --dim white)'Ctrl-A: '(set_color normal)(set_color --italics brblack)'Toggle local/all branches'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-O: '(set_color normal)(set_color --italics brblack)'Checkout branch'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-B: '(set_color normal)(set_color --italics brblack)'View branch in GitHub'
    end

    __fzf_header
end
