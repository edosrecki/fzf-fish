function __fzf_gh_prs_header
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

    __fzf_header $header
end
