function __fzf_idx
    function usage
        echo USAGE
        echo '  __fzf_idx --index <index> --total <total> [--step <step>] [--next|--prev]'
        echo ''
        echo FLAGS
        echo '  -i, --index  Current index'
        echo '  -t, --total  Total number of items'
        echo '  -s, --step   Step size (default: 1)'
        echo '  -n, --next   Get next index'
        echo '  -p, --prev   Get previous index'
        echo '  -h, --help   Print this help message'
    end

    argparse h/help 'i/index=' 't/total=' 's/step=' n/next p/prev -- $argv >/dev/null 2>&1; or set -f error true
    argparse --min-args 0 --max-args 0 -- $argv >/dev/null 2>&1; or set -f error true

    if set -q _flag_help
        usage
        return 0
    end

    if set -q error
        usage
        return 1
    end

    set -f i $_flag_index
    set -f n $_flag_total
    if set -q _flag_step
        set -f m $_flag_step
    else
        set -f m 1
    end

    if set -q _flag_next
        echo (math "($i + $m - 1) % $n + 1")
    else if set -q _flag_prev
        echo (math "($i - $m + $n - 1) % $n + 1")
    else
        echo $i
    end
end
