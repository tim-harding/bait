function _bait_spin
    if not argparse --stop-nonopt h/help o/stdout e/stderr style-spinner= style-title= title= \
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

    set -l unstyle (set_color normal)

    set -q BAIT_STYLE_SPINNER
    and set -l style_spinner $BAIT_STYLE_SPINNER
    set -q _flag_style_spinner
    and set -l style_spinner $_flag_style_spinner

    set -q BAIT_STYLE_TITLE
    and set -l style_title $BAIT_STYLE_TITLE
    set -q _flag_style_title
    and set -l style_title $_flag_style_title

    set -l align left
    set -q _flag_align
    and set align $_flag_align

    set -l spinner_kind dot
    set -q _flag_spinner
    and set spinner_kind $_flag_spinner

    set -l spinner
    switch $spinner_kind
        case dot
            set spinner ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷
        case minidot
            set spinner ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
        case pulse
            set spinner █ ▓ ▒ ░ " " ▒ ▓
        case points
            set spinner ∙∙∙ ●∙∙ ∙●∙ ∙∙●
        case line
            set spinner / - \\ \|
    end

    set -l title 'Working...'
    if set -q _flag_title
        set title $_flag_title
    end
    set title $style_title $title $unstyle

    set -l speed 8
    if set -q _flag_speed
        set speed $_flag_speed
    end

    if set -q _flag_stdout
        if set -q _flag_stderr
            $argv &
        else
            $argv 2>/dev/null &
        end
    else
        if set -q _flag_stderr
            $argv 1>/dev/null &
        else
            $argv &>/dev/null &
        end
    end
    set -l exit_code $status
    if not set -q last_pid
        return $exit_code
    end
    set -l exited _bait_spin_exited_$last_pid

    function _bait_spin_handle_exit --on-process-exit $last_pid -V exited --argument-names reason pid exit_code
        set -g $exited $exit_code
    end

    bait cursor hide >/dev/tty
    while not set -q $exited
        for c in $spinner
            if set -q $exited
                break
            end

            set c $style_spinner $c $unstyle

            set -l align_l
            set -l align_r
            switch $align
                case left
                    set align_l $c
                    set align_r $title
                case right
                    set align_l $title
                    set align_r $c
            end

            echo -ns $align_l ' ' $align_r >/dev/tty
            bait cursor column 1 >/dev/tty
            sleep (math 1 / $speed)
        end
    end
    bait cursor show >/dev/tty

    return $$exited
end

function _bait_spin_help
    echo -n "\
Usage: bait spin [flags] -- <command>

Display spinner while running a command

Flags:
  -h, --help                  Show context-sensitive help.
  -o, --stdout                Include command stdout in output
  -e, --stdout                Include command stderr in output
      --speed=8               Animation frame frequency
  -s, --spinner='dot'         Spinner type
      --title='Working...'    Text to display to user while spinning
  -a, --align='left'          Alignment of spinner with regard to the title
" 1>&2
end
