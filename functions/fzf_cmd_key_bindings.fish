function fzf_cmd_key_bindings
    status --is-interactive; or return

    ## Widgets
    ## ~~~~~~~
    function search-history-widget
        function colorize_history
            builtin history --null --show-time="%m-%d %H:%M:%S"\t |
                while read -z -l line
                    set -l parts (string split \t $line)
                    set -l date $parts[1]
                    set -l cmd $parts[2]

                    echo -n (set_color blue)$date(set_color normal)' │ '$cmd
                    printf "\0"
                end
        end

        if test -z "$fish_private_mode"
            builtin history merge
        end

        set -f time_prefix_regex '^.*? │ '
        set -f commands_selected (
            colorize_history |
            fzf --ansi \
                --read0 \
                --print0 \
                --multi \
                --scheme=history \
                --query=(commandline) \
                --preview="string replace -r '$time_prefix_regex' '' -- {} | fish_indent --ansi" \
                --preview-window="bottom:3:wrap" |
            string split0 |
            string replace -r $time_prefix_regex ''
        )

        if test $status -eq 0
            commandline -r -- $commands_selected
        end
        commandline -f repaint
    end

    ## Bindings
    ## ~~~~~~~~
    for mode in default insert
        bind --mode $mode \cr search-history-widget
    end
end
