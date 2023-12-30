function fzf_git_key_bindings
    status --is-interactive; or return

    ## Widgets
    ## ~~~~~~~
    function git-branches-widget
        __git_check; or return

        # Default options
        set -U __fzf_git_branches_all 0

        set -f branches (
            echo |
            fzf-tmux \
                -p "$__fzf_popup_width%" \
                --ansi \
                --multi \
                --info inline \
                --border-label '  Branches ' \
                --header-lines 1 \
                --bind="start:reload(__fzf_git_branches)+transform-header(__fzf_git_branches_header)" \
                --bind="load:transform-header(__fzf_git_branches_header)" \
                --bind='ctrl-a:reload(__fzf_git_branches --toggle-all)' \
                --bind='ctrl-b:execute-silent(__fzf_git_branch --action browse {})' \
                --bind='ctrl-o:execute-silent(__fzf_git_branch --action checkout {})+reload(__fzf_git_branches)' \
                --preview-window='down,border-top,50%' \
                --preview='__fzf_git_branch --action view {}' |
                string sub -s 3 | string split -f1 ' '
        )

        if test $status -eq 0
            commandline -i "$branches"
        end
        commandline -f repaint
    end

    function git-commits-widget
        __git_check; or return

        set -f commits (
            echo |
            fzf-tmux \
                -p "$__fzf_popup_width%" \
                --ansi \
                --multi \
                --info inline \
                --border-label '  Commits ' \
                --header-lines 1 \
                --bind="start:reload(__fzf_git_commits)" \
                --preview-window='down,border-top,50%' \
                --preview='__fzf_git_commit --action view {}' |
                string split -f1 ' '
        )

        if test $status -eq 0
            for commit in $commits
                set -fa commit_hashes (git rev-parse $commit)
            end
            commandline -i "$commit_hashes"
        end
        commandline -f repaint
    end

    function git-stashes-widget
        __git_check; or return

        set -f stashes (
            echo |
            fzf-tmux \
                -p "$__fzf_popup_width%" \
                --ansi \
                --multi \
                --info inline \
                --border-label '  Stashes ' \
                --header-lines 1 \
                --bind="start:reload(__fzf_git_stashes)" \
                --bind="ctrl-x:execute-silent(__fzf_git_stash --action drop {})+reload(__fzf_git_stashes)" \
                --preview-window='down,border-top,70%' \
                --preview='__fzf_git_stash --action view {}' |
                string split -f1 ' '
        )

        if test $status -eq 0
            commandline -i "$stashes"
        end
        commandline -f repaint
    end

    function gh-prs-widget
        __git_check; or return

        # Default options
        set -U __fzf_gh_prs_state_idx 1
        set -U __fzf_gh_prs_limit_idx 1

        set -f prs (
            echo |
            fzf-tmux \
                -p "$__fzf_popup_width%" \
                --ansi \
                --multi \
                --info inline \
                --border-label '  Pull Requests ' \
                --header-lines 1 \
                --bind="start:reload(__fzf_gh_prs)+transform-header(__fzf_gh_prs_header)" \
                --bind="load:transform-header(__fzf_gh_prs_header)" \
                --bind='ctrl-t:reload(__fzf_gh_prs --next-state)' \
                --bind='ctrl-alt-t:reload(__fzf_gh_prs --prev-state)' \
                --bind='ctrl-l:reload(__fzf_gh_prs --next-limit)' \
                --bind='ctrl-alt-l:reload(__fzf_gh_prs --prev-limit)' \
                --bind='ctrl-b:execute-silent(__fzf_gh_pr --action browse {})' \
                --bind='ctrl-o:execute-silent(__fzf_gh_pr --action checkout {})' \
                --preview-window='down,border-top,50%' \
                --preview='__fzf_gh_pr --action view {}' |
                string match -gr '^#([0-9]+)'
        )

        if test $status -eq 0
            commandline -i "$prs"
        end
        commandline -f repaint
    end

    function gh-repos-widget
        # Default options
        set -U __fzf_gh_repos_org_idx 1
        set -U __fzf_gh_repos_limit_idx 1

        set -f repos (
            echo |
            fzf-tmux \
                -p "$__fzf_popup_width%" \
                --ansi \
                --multi \
                --info inline \
                --border-label '  Repositories ' \
                --header-lines 1 \
                --bind="start:reload(__fzf_gh_repos {q})+transform-header(__fzf_gh_repos_header)" \
                --bind="change:reload(__fzf_gh_repos {q})" \
                --bind="load:transform-header(__fzf_gh_repos_header)" \
                --bind="ctrl-g:reload(__fzf_gh_repos --next-org {q})" \
                --bind="ctrl-alt-g:reload(__fzf_gh_repos --prev-org {q})" \
                --bind="ctrl-l:reload(__fzf_gh_repos --next-limit {q})" \
                --bind="ctrl-alt-l:reload(__fzf_gh_repos --prev-limit {q})" \
                --bind='ctrl-b:execute-silent(__fzf_gh_repo --action browse {})' \
                --bind='ctrl-o:execute-silent(__fzf_gh_repo --action clone {})' \
                --preview-window='down,border-top,50%' \
                --preview='__fzf_gh_repo --action view {}' |
                string match -gr '^([^ ]+) +([^ ]+)' | string join '/'
        )

        if test $status -eq 0
            commandline -i "$repos"
        end
        commandline -f repaint
    end

    ## Helpers
    ## ~~~~~~~
    function __git_check
        command -q git; and git rev-parse HEAD >/dev/null 2>&1
    end

    ## Bindings
    ## ~~~~~~~~
    bind \cg\cb git-branches-widget
    bind \cg\ct git-stashes-widget
    bind \cg\cl git-commits-widget
    bind \cg\cp gh-prs-widget
    bind \cg\cr gh-repos-widget
end
