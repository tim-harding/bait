function _bait_ui_teardown
    string join \n $_bait_ui_old_prompt | source
    set fish_bind_mode $_bait_ui_old_bind_mode
    _bait_cursor show
end
