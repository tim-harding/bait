function _bait_choose --argument-names key
    if not set -q _bait_state
        set -g _bait_state 0
        set -g _bait_options $argv
    end

    switch $key
        case up
            set _bait_state (math "($_bait_state - 1 + $(count $_bait_options))")
        case down
            set _bait_state (math "($_bait_state + 1)")
        case enter
            echo $_bait_options[(math "$_bait_state + 1")]
            set -g _tackle_exit 0
            return
        case escape
            set -g _tackle_exit 1
            return
    end
    set _bait_state (math "$_bait_state % $(count $_bait_options)")

    echo "Choose:"
    for i in (seq (count $_bait_options))
        if test (math "$_bait_state + 1") -eq $i
            echo -n "> "
        else
            echo -n "  "
        end
        echo $_bait_options[$i]
    end
end
