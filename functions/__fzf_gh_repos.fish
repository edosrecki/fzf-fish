function __fzf_gh_repos  
  function usage
    echo 'USAGE'
    echo '  __fzf_gh_repos [--next-org|--prev-org] [--next-limit|--prev-limit] <query>'
    echo ''
    echo 'FLAGS'
    echo '  --next-org    Select next organization'
    echo '  --prev-org    Select previous organization'
    echo '  --next-limit  Select next limit'
    echo '  --prev-limit  Select previous limit'
    echo '  -h, --help    Print this help message'
  end

  argparse 'h/help' 'next-org' 'prev-org' 'next-limit' 'prev-limit' -- $argv >/dev/null 2>&1; or set -f error true
  argparse --min-args 1 --max-args 1 -- $argv >/dev/null 2>&1; or set -f error true

  if set -q _flag_help
    usage
    return 0
  end

  if set -q error
    usage
    return 1
  end

  # Select organization
  begin
    set -l i $__fzf_gh_repos_org_idx
    set -l t (count $__fzf_gh_repos_orgs)
    set -q _flag_next_org; and set -l d '--next'
    set -q _flag_prev_org; and set -l d '--prev'

    set -U __fzf_gh_repos_org_idx (__fzf_idx $d -i $i -t $t)
  end
  
  # Select limit
  begin
    set -l i $__fzf_gh_repos_limit_idx
    set -l t (count $__fzf_gh_repos_limits)
    set -q _flag_next_limit; and set -l d '--next'
    set -q _flag_prev_limit; and set -l d '--prev'
      
    set -U __fzf_gh_repos_limit_idx (__fzf_idx $d -i $i -t $t)
  end

  # Search repositories
  set -f query $argv[1]

  if test $__fzf_gh_repos_orgs[$__fzf_gh_repos_org_idx] != 'ᴀʟʟ'
    set -f owner --owner $__fzf_gh_repos_orgs[$__fzf_gh_repos_org_idx]
  end

  set -f repos (
    gh search repos $query \
      $owner \
      --limit $__fzf_gh_repos_limits[$__fzf_gh_repos_limit_idx] \
      --match 'name' \
      --json 'owner,name,visibility,pushedAt' \
      --template '{{ range . }}{{ printf "%s\t" .owner.login }}{{ printf "%.50s\t" .name }}{{ printf "%s\t" .visibility }}{{ printf "%s\t" (timeago .pushedAt) }}{{ printf "\n" }}{{ end }}'
  )

  # Format results
  set -fa result (set_color --bold white)'Owner'\t'Name'\t(set_color white)'Visibility'\t(set_color white)'Updated'(set_color normal)
  for repo in $repos
    set -f arr (string split \t $repo)
    set -f owner $arr[1]
    set -f name $arr[2]
    set -f visibility $arr[3]
    set -f date $arr[4]

    set -a result (set_color white)$owner\t$name\t(set_color blue)"$visibility"\t(set_color blue)"$date"(set_color normal)
  end

  printf "%s\n" $result | __fzf_column
end
