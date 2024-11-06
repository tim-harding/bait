function _bait_input --inherit-variable BAIT_STYLE_PROMPT
    argparse h/help password 'prompt=?' 'value=?' 'style-prompt=?' -- $argv
    or return

    if set -q _flag_help
        echo -n "Usage: bait input [flags]

Prompt for some input

Flags:
  -h, --help                     Show context-sensitive help
      --prompt='> '              Prompt to display
      --value=''                 Initial value (can also be passed via stdin)
      --password                 Mask input characters
      --style-prompt='black'     set_color flags for prompt (or set BAIT_STYLE_PROMPT)
" &>stderr
        return
    end

    if set -q _flag_prompt
        set prompt $_flag_prompt
    else
        set prompt "> "
    end

    if set -q _flag_value
        set value $_flag_value
    else if not isatty
        read value
    else
        set value
    end

    if set -q _flag_style_prompt
        set style_prompt $_flag_style_prompt
    else if set -q BAIT_STYLE_PROMPT
        set style_prompt $BAIT_STYLE_PROMPT
    else
        set style_prompt black
    end

    read --command "$value" \
        (set -q _flag_password; and echo --silent) \
        --prompt "set_color $style_prompt; echo -n '$prompt'" input </dev/tty
    bait cursor line-up 1 >/dev/tty
    bait erase line-all >/dev/tty
    echo $input
end
