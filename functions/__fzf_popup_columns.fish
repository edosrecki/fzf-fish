function __fzf_popup_columns
    set -f window_width (tmux display-message -p '#{window_width}')
    # fzf tmux popup uses 7 columns for border and padding by default
    set -f padding 7
    set -f width (math "floor($__fzf_popup_width / 100 * $window_width) - $padding")

    echo $width
end
