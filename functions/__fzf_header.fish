function __fzf_header -V header -V help
    # Header
    set header (string join ' ┆ ' $header)
    echo (string pad -w (__fzf_popup_columns) $header)

    # Help
    if test -n "$help"
        set help (string join ' ┆ ' $help)
        echo (string pad -w (__fzf_popup_columns) $help)(set_color normal)
    end

    # Separator
    echo (set_color brblack)(string repeat -n (__fzf_popup_columns) '─')(set_color normal)
end
