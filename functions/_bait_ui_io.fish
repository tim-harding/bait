function _bait_ui_io
    echo -es $argv >/dev/tty
    read -g --prompt "bait cloak hide" _bait_ui_input
    bait cloak show
    bait cursor line-up (math 1 + (count (string join $argv))) >/dev/tty
    bait erase to-end >/dev/tty
    set_color normal >/dev/tty
end
