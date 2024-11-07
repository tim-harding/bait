function _bait_spin
    if not argparse --stop-nonopt h/help show-output show-error 'title=' \
            'speed=!_fish_validate_int --min 1' \
            'spinner=!contains $_flag_value dot line minidot pulse points' \
            'align=!contains $_flag_value left right' -- $argv
        _bait_spin_help
        return 1
    end

    if set -q _flag_help
        _bait_spin_help
        return
    end

    set spinner_1 ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷
    set spinner_2 ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
    set spinner_3 █ ▓ ▒ ░ " " ▒ ▓
    set spinner_4 ∙∙∙ ●∙∙ ∙●∙ ∙∙●
    set spinner_5 / - \\ \|

    if set -q _flag_spinner
        set spinner_kind $_flag_spinner
    else
        set spinner_kind dot
    end

    switch $spinner_kind
        case dot
            set spinner $spinner_1
        case minidot
            set spinner $spinner_2
        case pulse
            set spinner $spinner_3
        case points
            set spinner $spinner_4
        case line
            set spinner $spinner_5
    end

    if set -q _flag_title
        set title $_flag_title
    else
        set title 'Working...'
    end

    if set -q _flag_speed
        set speed $_flag_speed
    else
        set speed 8
    end

    $argv &
    set exit_code $status
    if not set pid (jobs --last --pid)
        return $exit_code
    end
    set exited _bait_spin_exited_$pid

    function _bait_spin_handle_exit --on-process-exit $pid -V exited --argument-names reason pid exit_code
        set -g $exited $exit_code
    end

    bait cursor hide >/dev/tty
    while not set -q $exited
        for c in $spinner
            if set -q $exited
                break
            end
            echo -ns "$c $title" >/dev/tty
            bait cursor column 1 >/dev/tty
            sleep (math 1 / $speed)
        end
    end
    bait cursor show >/dev/tty

    return $$exited
end

function _bait_spin_help
    echo -n "Usage: bait spin [flags] -- <command>

Display spinner while running a command

Flags:
  -h, --help                  Show context-sensitive help.
      --show-output           Show or pipe output of command during execution
      --show-error            Show output of command only if the command fails
      --speed=8               Animation frame frequency
  -s, --spinner='dot'         Spinner type
      --title='Working...'    Text to display to user while spinning
  -a, --align='left'          Alignment of spinner with regard to the title
" 1>&2
end
