function __fzf_gh_repos_header
  set -f header

  # Organizations
  set -f orgs
  for i in (seq (count $__fzf_gh_repos_orgs))
    if test $i -eq $__fzf_gh_repos_org_idx
      set -a orgs (set_color --bold --dim white)"$__fzf_gh_repos_orgs[$i]"(set_color normal)(set_color brblack)
    else
      set -a orgs (set_color brblack)"$__fzf_gh_repos_orgs[$i]"(set_color normal)(set_color brblack)
    end
  end
  set -a header (set_color brblack)'Owner: '(string join ',' $orgs)

  # Limits
  set -f limits
  for i in (seq (count $__fzf_gh_repos_limits))
    if test $i -eq $__fzf_gh_repos_limit_idx
      set -a limits (set_color --bold --dim white)"$__fzf_gh_repos_limits[$i]"(set_color normal)(set_color brblack)
    else
      set -a limits (set_color brblack)"$__fzf_gh_repos_limits[$i]"(set_color normal)(set_color brblack)
    end
  end
  set -a header (set_color brblack)'Limit: '(string join ',' $limits)

  __fzf_header $header
end
