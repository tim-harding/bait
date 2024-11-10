function _bait_ui_io
    echo -es $argv >/dev/tty
    echo >/dev/tty
    _bait_cursor line-up 1 >/dev/tty
    read -g --prompt "bait cloak hide" _bait_ui_input
    or set -g _bait_ui_input cancel
    _bait_cloak show
    _bait_cursor line-up (math 1 + (count (string join $argv))) >/dev/tty
    _bait_erase to-end >/dev/tty
    set_color normal >/dev/tty
end
