function __fzf_gh_pr
    function usage
      echo 'USAGE'
      echo '  __fzf_gh_pr --action <action> <pr>'
      echo ''
      echo 'FLAGS'
      echo '  -a, --action (parse|checkout|browse|view)  Specify an action to perform on a PR'
      echo '  -h, --help                                 Print this help message'
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
    set -f pr $argv[1]
  
    switch $action
      # Parse output from __fzf_gh_prs and return PR number
      case 'parse'
        set -f number (string match -gr '^#([0-9]+)' $pr)

        echo $number
      # Checkout a PR locally
      case 'checkout'
        set -f number (__fzf_gh_pr --action parse $pr)
  
        gh pr checkout $number
      # Open a PR in the browser
      case 'browse'
        set -f number (__fzf_gh_pr --action parse $pr)
        
        gh pr view --web $number
      # Print PR details
      case 'view'
        set -f number (__fzf_gh_pr --action parse $pr)
        
        GH_FORCE_TTY=true gh pr view $number
      case '*'
        usage
        return 1
    end
  end
  