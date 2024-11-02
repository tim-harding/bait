function _bait_confirm_update
    if test $_bait_state_confirm -eq 0
        set _bait_state_confirm 1
    else
        set _bait_state_confirm 0
    end
end
