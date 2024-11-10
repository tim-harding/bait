# TODO: 
# - Support multiselect
function _bait_choose
    argparse \
        h/help \
        select-if-one \
        cursor= \
        header= \
        selected-prefix= \
        unselected-prefix= \
        'limit=!_fish_validate_int --min 1' \
        -- $argv
    or begin
        _bait_choose_help
        return 1
    end

    if set -q _flag_help
        _bait_choose_help
        return
    end

    set -l options $argv
    if not isatty stdin
        while read line
            set -a options line
        end
    end

    set -l choice 0
    set -l query ""
    set -l exit_code 0
    set -l filtered $options
    set -l filtered_len (count $filtered)

    _bait_ui_setup
    while true
        set -l lines Choose: $query \n
        for i in (seq $filtered_len)
            if test (math "$i - 1") -eq $choice
                set -a lines "> "
            else
                set -a lines "  "
            end
            set -a lines $filtered[$i] \n
        end
        _bait_ui_io $lines

        switch $_bait_ui_input
            case escape cancel
                set exit_code 1
                break
            case a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
                set query (string join "" $query $_bait_ui_input)
            case backspace
                set query (string sub --start 1 --end -1 $query)
            case \cW
                set query ""
        end

        set filtered (string match "*$query*" $options)
        set filtered_len (count $filtered)
        set choice (math "min($choice, max(0, $filtered_len - 1))")

        switch $_bait_ui_input
            case down
                set choice (math "($choice + 1) % $filtered_len")
            case up
                set choice (math "($choice - 1 + $filtered_len) % $filtered_len")
            case enter
                break
        end
    end

    _bait_ui_teardown
    if test $exit_code -eq 0
        set -l index (math "$choice + 1")
        if set -q filtered[$index]
            echo $filtered[$index]
        end
    end
    return $exit_code
end

function _bait_choose_help
    echo -n "\
Usage: bait choose [<options> ...] [flags]

Choose an option from a list of choices

Arguments:
  [<options> ...]    Options to choose from.

Flags:
  -h, --help                      Show context-sensitive help.
      --cursor=" >"               Prefix to show on item that corresponds to the cursor position
      --header="Choose:"          Header value 
      --selected-prefix="✓ "      Prefix to show on selected items (hidden if limit is 1)
      --unselected-prefix="• "    Prefix to show on unselected items (hidden if limit is 1)
      --limit=1                   Maximum number of options to pick
      --select-if-one             Select the given option if there is only one
" 1>&2
end
