function _bait_confirm --argument-names key
    # TODO: 
    # Rerunning this every update. 
    # Maybe invert it so we call UI functions. 
    argparse h/help y/default-yes affirmative= negative= style-text= style-selected= style-unselected= -- $argv[2..]
    or begin
        _bait_confirm_help
        return 1
    end

    set -q _flag_help
    and begin
        _bait_confirm_help
        return
    end

    if not set -q _bait_confirm_state
        set -q _flag_default_yes
        and set -g _bait_confirm_state 0
        or set -g _bait_confirm_state 1
    end

    switch $key
        case left right h l
            set _bait_confirm_state (math "($_bait_confirm_state + 1) % 2")
        case y
            set -g _bait_exit 0
            return
        case n escape
            set -g _bait_exit 1
            return
        case enter
            set -g _bait_exit $_bait_confirm_state
            return
    end

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

    set -l style_yes
    set -l style_no
    if test $_bait_confirm_state -eq 0
        set style_yes $style_selected
        set style_no $style_unselected
    else
        set style_yes $style_unselected
        set style_no $style_selected
    end

    echo -s $style_text $text
    echo -s $style_yes "  $yes  " (set_color normal) "  " $style_no "  $no  "
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
