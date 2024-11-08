function _bait_ui --argument-names fn
    if test -z $fn
        return 1
    end

    set -l old \
        (functions fish_prompt) \
        (functions fish_right_prompt) \
        (functions fish_mode_prompt)

    _bait_keybind
    set -l old_bind_mode $fish_bind_mode
    set fish_bind_mode bait
    commandline -f repaint-mode

    function fish_prompt
    end
    function fish_right_prompt
    end
    function fish_mode_prompt
    end

    set -l input ""
    set -l compensate
    bait cursor hide
    while true
        set lines ($fn $input $argv[2..])

        echo -ns $compensate \
            (bait erase to-end) \
            (set_color normal) >/dev/tty

        if set -q _bait_exit
            bait cursor show
            for line in $lines
                echo $line
            end
            break
        end

        string join \n $lines >/dev/tty
        read --prompt "bait cloak hide" input
        set compensate \
            (bait cursor line-up (math 1 + (count $lines))) \
            (bait cloak show)
    end

    string join \n $old | source
    set fish_bind_mode $old_bind_mode

    set -l _bait_exit_temp $_bait_exit
    set --erase _bait_exit
    return $_bait_exit_temp
end

function _bait_key
    commandline --insert $argv
    commandline --function execute
end
