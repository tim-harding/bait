function _bait_confirm
    argparse \
        h/help \
        y/default-yes \
        affirmative= \
        negative= \
        style-text= \
        style-selected= \
        style-unselected= \
        -- $argv[2..]
    or begin
        _bait_confirm_help
        return 1
    end

    set -q _flag_help
    and begin
        _bait_confirm_help
        return
    end

    set -q _flag_default_yes
    and set -l state 0
    or set -l state 1

    set -l style_text (set_color normal)
    set -q _flag_style_text
    and set style_text $_flag_style_text

    set -l style_selected (set_color red --reverse)
    set -q _flag_style_selected
    and set style_selected $_flag_style_selected

    set -l style_unselected (set_color --reverse --dim)
    set -q _flag_style_unselected
    and set style_unselected $_flag_style_unselected

    set -l yes YES
    set -q _flag_affirmative
    and set yes $_flag_affirmative

    set -l no NO
    set -q _flag_negative
    and set no $_flag_negative

    set -l text "Are you sure?"
    test (count $argv) -ge 1
    and set text $argv

    _bait_ui_setup
    while true
        set -l style_yes
        set -l style_no
        if test $state -eq 0
            set style_yes $style_selected
            set style_no $style_unselected
        else
            set style_yes $style_unselected
            set style_no $style_selected
        end

        _bait_ui_io $style_text $text \n \
            $style_yes "  $yes  " (set_color normal) "  " $style_no "  $no  "

        switch $_bait_ui_input
            case left right h l
                set state (math "($state + 1) % 2")
            case y
                set state 0
                break
            case n escape
                set state 1
                break
            case enter
                break
        end
    end

    _bait_ui_teardown
    return $state
end

function _bait_confirm_help
    echo -n "\
Usage: bait confirm [<prompt>] [flags]

Ask a user to confirm an action

Arguments:
  [<prompt>]    Prompt to display.

Flags:
  -h, --help                      Show context-sensitive help.
  -y, --default-yes               Default selection is affirmative
      --affirmative="Yes"         The title of the affirmative action
      --negative="No"             The title of the negative action
      --style-text=STYLE          Text style
      --style-selected=STYLE      Text style
      --style-unselected=STYLE    Text style
" 1>&2
end
