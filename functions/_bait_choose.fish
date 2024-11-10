function _bait_choose --argument-names key
    argparse h/help select-if-one cursor= header= selected-prefix= unselected-prefix= \
        'limit=!_fish_validate_int --min 1' -- $argv
    or begin
        _bait_choose_help
        return 1
    end

    if set -q _flag_help
        _bait_choose_help
        return
    end

    if not set -q choice
        set -g choice 0
        set -g options $argv
    end

    switch $key
        case up
            set choice (math "($choice - 1 + $(count $options))")
        case down
            set choice (math "($choice + 1)")
        case enter
            echo $options[(math "$choice + 1")]
            set -g _bait_exit 0
            return
        case escape
            set -g _bait_exit 1
            return
    end
    set choice (math "$choice % $(count $options)")

    echo "Choose:"
    for i in (seq (count $options))
        if test (math "$choice + 1") -eq $i
            echo -n "> "
        else
            echo -n "  "
        end
        echo $options[$i]
    end
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
