function __fzf_git_commits
  function usage
    echo 'USAGE'
    echo '  __fzf_git_commits'
    echo ''
    echo 'FLAGS'
    echo '  -h, --help    Print this help message'
  end

  argparse 'h/help' -- $argv >/dev/null 2>&1; or set -f error true
  argparse --min-args 0 --max-args 0 -- $argv >/dev/null 2>&1; or set -f error true

  if set -q _flag_help
    usage
    return 0
  end

  if set -q error
    usage
    return 1
  end

  # Get commits
  set -l commits (git log --format='%h'\t'%s'\t'%an'\t'%ar')

  # Format results
  set -fa result (set_color --bold white)'Commit'\t'Message'\t(set_color white)'Author'\t(set_color white)'Created'(set_color normal)
  for commit in $commits
    set -f arr (string split \t $commit)
    set -f hash $arr[1]
    set -f message $arr[2]
    set -f author $arr[3]
    set -f date $arr[4]

    if test (__fzf_length $message) -gt 80
      set -f message (string sub -l 80 $message)'...'
    end

    set -a result $hash\t$message\t(set_color blue)$author\t(set_color blue)$date(set_color normal)
  end

  printf "%s\n" $result | __fzf_column
end
