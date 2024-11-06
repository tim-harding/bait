function _bait_filter --argument-names key
    if not set -q choice
        set -g query ""
        set -g choice 0
        set -g options $argv
        if not isatty stdin
            while read line
                set --append options line
            end
        end
    end

    switch $key
        case backspace
            set query (string sub --start 1 --end -1 $query)
        case escape
            set -g _bait_exit 1
            return
        case a b c d e f g h i j k l m n o p q r s t u v w x y z
            set query (string join "" $query $key)
    end

    set filtered (string match "*$query*" $options)
    set filtered_len (count $filtered)
    set choice (math "min($choice, max(0, $filtered_len - 1))")

    switch $key
        case down
            set choice (math "($choice + 1) % $filtered_len")
        case up
            set choice (math "($choice - 1 + $filtered_len) % $filtered_len")
        case enter
            set index (math "$choice + 1")
            if set -q filtered[$index]
                echo $filtered[$index]
            end
            set -g _bait_exit 0
            return
    end

    echo "filter: $query"
    for i in (seq $filtered_len)
        if test (math "$i - 1") -eq $choice
            echo -n "> "
        else
            echo -n "  "
        end
        echo $filtered[$i]
    end
end
