function __fzf_gh_prs
  function usage
    echo 'USAGE'
    echo '  __fzf_gh_prs [--next-state|--prev-state] [--next-limit|--prev-limit]'
    echo ''
    echo 'FLAGS'
    echo '  --next-state  Select next PR state'
    echo '  --prev-state  Select previous PR state'
    echo '  --next-limit  Select next limit'
    echo '  --prev-limit  Select previous limit'
    echo '  -h, --help    Print this help message'
  end

  argparse 'h/help'  'next-state' 'prev-state' 'next-limit' 'prev-limit' -- $argv >/dev/null 2>&1; or set -f error true
  argparse --min-args 0 --max-args 0 -- $argv >/dev/null 2>&1; or set -f error true

  if set -q _flag_help
    usage
    return 0
  end

  if set -q error
    usage
    return 1
  end

  # Set state
  begin
    set -l i $__fzf_gh_prs_state_idx
    set -l t (count $__fzf_gh_prs_states)
    set -q _flag_next_state; and set -l d '--next'
    set -q _flag_prev_state; and set -l d '--prev'

    set -U __fzf_gh_prs_state_idx (__fzf_idx $d -i $i -t $t)
  end

  # Set limit
  begin
    set -l i $__fzf_gh_prs_limit_idx
    set -l t (count $__fzf_gh_prs_limits)
    set -q _flag_next_limit; and set -l d '--next'
    set -q _flag_prev_limit; and set -l d '--prev'

    set -U __fzf_gh_prs_limit_idx (__fzf_idx $d -i $i -t $t)
  end

  # Search PRs
  set -f prs (
    gh pr list \
      --state $__fzf_gh_prs_states[$__fzf_gh_prs_state_idx] \
      --limit $__fzf_gh_prs_limits[$__fzf_gh_prs_limit_idx] \
      --json 'number,title,author,createdAt,state' \
      --template '{{ range . }}{{ printf "#%v\t" .number }}{{ printf "%.80s\t" .title }}{{ printf "%s\t" .author.login }}{{ printf "%s\t" (timeago .createdAt) }}{{ printf "%s\t" .state }}{{ printf "\n" }}{{ end }}'
  )

  # Format results
  set -fa result (set_color --bold white)'Number'\t(set_color white)'Title'\t(set_color white)'Author'\t(set_color white)'Created'(set_color normal)
  for pr in $prs
    set -f arr (string split \t $pr)
    set -f number $arr[1]
    set -f title $arr[2]
    set -f author $arr[3]
    set -f date $arr[4]
    set -f state $arr[5]

    if test $state = 'OPEN'
      set -f state_color green
    else if test $state = 'CLOSED'
      set -f state_color red
    else if test $state = 'MERGED'
      set -f state_color magenta
    else
      set -f state_color normal
    end

    set -a result (set_color $state_color)$number\t(set_color white)"$title"\t(set_color blue)"$author"\t(set_color blue)"$date"(set_color normal)
  end

  printf "%s\n" $result | __fzf_column
end
