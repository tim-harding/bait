function _bait_choose --argument-names key
    if not set -q choice
        set -g choice 0
        set -g options $argv
    end

    switch $key
        case up
            set choice (math "($choice - 1 + $(count $options))")
        case down
            set choice (math "($choice + 1)")
        case enter
            echo $options[(math "$choice + 1")]
            set -g _tackle_exit 0
            return
        case escape
            set -g _tackle_exit 1
            return
    end
    set choice (math "$choice % $(count $options)")

    echo "Choose:"
    for i in (seq (count $options))
        if test (math "$choice + 1") -eq $i
            echo -n "> "
        else
            echo -n "  "
        end
        echo $options[$i]
    end
end
