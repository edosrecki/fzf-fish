function __fzf_gh_prs_header
    function usage
        echo USAGE
        echo '  __fzf_gh_prs_header [--toggle-help]'
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
        set -q __fzf_gh_prs_help; or set -U __fzf_gh_prs_help 0
        set -U __fzf_gh_prs_help (math "bitxor($__fzf_gh_prs_help, 1)")
    end

    # States
    for i in (seq (count $__fzf_gh_prs_states))
        set -l state (__fzf_capitalize $__fzf_gh_prs_states[$i])
        if test $i -eq $__fzf_gh_prs_state_idx
            set -fa states (set_color --bold --dim white)"$state"(set_color normal)(set_color brblack)
        else
            set -fa states (set_color brblack)"$state"(set_color normal)(set_color brblack)
        end
    end
    set -fa header (set_color brblack)'State: '(string join ',' $states)

    # Limits
    for i in (seq (count $__fzf_gh_prs_limits))
        if test $i -eq $__fzf_gh_prs_limit_idx
            set -fa limits (set_color --bold --dim white)"$__fzf_gh_prs_limits[$i]"(set_color normal)(set_color brblack)
        else
            set -fa limits (set_color brblack)"$__fzf_gh_prs_limits[$i]"(set_color normal)(set_color brblack)
        end
    end
    set -fa header (set_color brblack)'Limit: '(string join ',' $limits)

    # Help
    if test $__fzf_gh_prs_help -eq 1
        set -fa help (set_color --italics --bold --dim white)'Ctrl-[Alt]-T: '(set_color normal)(set_color --italics brblack)'Switch between PR states'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-[Alt]-L: '(set_color normal)(set_color --italics brblack)'Switch between limits'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-B: '(set_color normal)(set_color --italics brblack)'View PR in GitHub'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-O: '(set_color normal)(set_color --italics brblack)'Checkout PR branch'
    end

    __fzf_header
end
