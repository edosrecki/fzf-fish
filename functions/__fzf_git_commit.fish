function __fzf_git_commit
    function usage
      echo 'USAGE'
      echo '  __fzf_git_commit --action <action> <commit>'
      echo ''
      echo 'FLAGS'
      echo '  -a, --action (parse, view)  Specify an action to perform on a commit'
      echo '  -h, --help                  Print this help message'
    end
  
    argparse 'h/help' 'a/action=' -- $argv >/dev/null 2>&1; or set -f error true
    argparse --min-args 1 --max-args 1 -- $argv >/dev/null 2>&1; or set -f error true
  
    if set -q _flag_help
      usage
      return 0
    end
  
    if set -q error
      usage
      return 1
    end
  
    set -f action $_flag_action
    set -f commit $argv[1]
  
    switch $action
      # Parse output from __fzf_git_commits and return commit id
      case 'parse'
        set -l hash (string split -f1 ' ' $commit)
  
        echo $hash
      # Show commit in preview window
      case 'view'
        set -l hash (__fzf_git_commit --action parse $commit)
  
        git show --color=always --stat --patch $hash | __fzf_delta
      case '*'
        usage
        return 1
    end
  end
  