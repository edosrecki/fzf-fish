function __fzf_header
    set -f header $argv

    # Header
    set header (string join ' ┆ ' $header)
    echo (string pad -w (__fzf_popup_columns) $header)

    # Separator
    echo (set_color brblack)(string repeat -n (__fzf_popup_columns) '─')(set_color normal)
end
