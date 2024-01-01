function __fzf_gh_repos_header
    function usage
        echo USAGE
        echo '  __fzf_gh_repos_header [--toggle-help]'
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
        set -q __fzf_gh_repos_help; or set -U __fzf_gh_repos_help 0
        set -U __fzf_gh_repos_help (math "bitxor($__fzf_gh_repos_help, 1)")
    end

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

    # Help
    if test $__fzf_gh_repos_help -eq 1
        set -fa help (set_color --italics --bold --dim white)'Ctrl-[Alt]-G: '(set_color normal)(set_color --italics brblack)'Switch between organizations'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-[Alt]-L: '(set_color normal)(set_color --italics brblack)'Switch between limits'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-B: '(set_color normal)(set_color --italics brblack)'View repository in GitHub'
        set -fa help (set_color --italics --bold --dim white)'Ctrl-O: '(set_color normal)(set_color --italics brblack)'Clone repository'
    end

    __fzf_header
end
