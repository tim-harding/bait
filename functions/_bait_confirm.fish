function _bait_confirm --argument-names key
    if not set -q _bait_state
        set -g _bait_state 0
    end

    switch $key
        case left right
            set _bait_state (math "($_bait_state + 1) % 2")
        case y
            set -g _tackle_exit 0
            return
        case n escape
            set -g _tackle_exit 1
            return
        case enter
            set -g _tackle_exit $_bait_state
            return
    end

    if test $_bait_state -eq 0
        set yes_color red
        set no_color normal
    else
        set yes_color normal
        set no_color red
    end

    echo "Are you sure?"
    set_color $yes_color --reverse
    echo -n "  YES  "
    set_color $no_color --reverse
    echo -n "  NO  "
end
