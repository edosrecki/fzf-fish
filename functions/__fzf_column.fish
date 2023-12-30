function __fzf_column
  if set -q __fzf_column_cmd
    eval "$__fzf_column_cmd"
  else
    column -t -s\t
  end
end
