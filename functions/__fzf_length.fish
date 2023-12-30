function __fzf_length
    # Remove ANSI escape sequences and count the length of the string
    echo $argv[1] | string replace -ra '(\e\[[^m]*m)|(\e\(B)' '' | string length
end
