function bait
    set command $argv[1]
    switch $command
        case confirm
            tackle -i_bait_confirm_init -u_bait_confirm_update -v_bait_confirm_view
    end
end

function _bait_confirm_init
    set -g _bait_state_confirm 0
    _tackle_state _bait_state_confirm
end

function _bait_confirm_update
    if test $_bait_state_confirm -eq 0
        set _bait_state_confirm 1
    else
        set _bait_state_confirm 0
    end
end

function _bait_confirm_view
    set selected $(_tackle_style -fblack -bred)
    set unselected $(_tackle_style -fblack -bwhite)
    set reset $(_tackle_style)

    if test $_bait_state_confirm -eq 0
        set yes $selected
        set no $unselected
    else
        set yes $unselected
        set no $selected
    end

    _tackle_cursor_save
    _tackle_erase_to_end
    _e "Are you sure?\n$yes  YES  $reset  $no  NO  $reset"
    _tackle_cursor_restore
end
