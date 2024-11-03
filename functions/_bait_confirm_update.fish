function _bait_confirm_update --argument-names key
    switch $key
        case left right
            if test $_bait_state_confirm -eq 0
                set _bait_state_confirm 1
            else
                set _bait_state_confirm 0
            end
        case y
            set -g _tackle_exit 0
        case n
            set -g _tackle_exit 1
        case enter
            set -g _tackle_exit $_bait_state_confirm
    end
end
