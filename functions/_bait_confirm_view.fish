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

    # _tackle_cursor save
    _tackle_erase to_end
    echo -nes "Are you sure?\n$yes  YES  $reset  $no  NO  $reset"
    # _tackle_cursor restore
end
