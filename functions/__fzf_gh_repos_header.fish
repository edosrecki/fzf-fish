function __fzf_gh_repos_header
    # Organizations
    for i in (seq (count $__fzf_gh_repos_orgs))
        set -f org $__fzf_gh_repos_orgs[$i]
        if test $org = ''
            set -f org (set_color --italics)All(set_color normal)
        end

        if test $i -eq $__fzf_gh_repos_org_idx
            set -fa orgs (set_color --bold --dim white)$org(set_color normal)(set_color brblack)
        else
            set -fa orgs (set_color brblack)$org(set_color normal)(set_color brblack)
        end
    end
    set -fa header (set_color brblack)'Owner: '(string join ',' $orgs)

    # Limits
    for i in (seq (count $__fzf_gh_repos_limits))
        if test $i -eq $__fzf_gh_repos_limit_idx
            set -fa limits (set_color --bold --dim white)"$__fzf_gh_repos_limits[$i]"(set_color normal)(set_color brblack)
        else
            set -fa limits (set_color brblack)"$__fzf_gh_repos_limits[$i]"(set_color normal)(set_color brblack)
        end
    end
    set -fa header (set_color brblack)'Limit: '(string join ',' $limits)

    __fzf_header $header
end
