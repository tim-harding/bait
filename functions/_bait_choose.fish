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

    set -l choice 0
    set -l exit_code 0

    _bait_ui_setup
    while true
        set -l lines Choose: \n
        for i in (seq (count $argv))
            if test (math $choice + 1) -eq $i
                set -a lines "> "
            else
                set -a lines "  "
            end
            set -a lines $argv[$i] \n
        end
        _bait_ui_io $lines

        switch $_bait_ui_input
            case up
                set choice (math $choice - 1 + (count $argv))
            case down
                set choice (math $choice + 1)
            case enter
                break
            case escape
                set exit_code 1
                break
        end
        set choice (math $choice % (count $argv))
    end

    _bait_ui_teardown
    echo $argv[(math $choice + 1)]
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
