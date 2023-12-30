function __fzf_capitalize
  set -f word $argv[1]
  set -f first (echo $word | string sub -l 1 | string upper)
  set -f rest (echo $word | string sub -s 2 | string lower)

  echo "$first$rest"
end
