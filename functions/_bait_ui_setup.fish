function _bait_ui_setup
    set -g _bait_ui_old_prompt \
        (functions fish_prompt) \
        (functions fish_right_prompt) \
        (functions fish_mode_prompt)

    _bait_keybind
    set -g _bait_ui_old_bind_mode $fish_bind_mode
    set fish_bind_mode bait
    commandline -f repaint-mode

    function fish_prompt
    end
    function fish_right_prompt
    end
    function fish_mode_prompt
    end

    bait cursor hide
end
