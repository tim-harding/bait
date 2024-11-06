function _bait_input -V BAIT_STYLE_PROMPT -V BAIT_STYLE_VALUE
    argparse h/help password 'prompt=?' 'value=?' 'style-prompt=?' 'style-value=?' -- $argv
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
      --style-value='normal'     set_color flags for value  (or set BAIT_STYLE_VALUE)
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

    if set -q _flag_style_value
        set style_value $_flag_style_value
    else if set -q BAIT_STYLE_VALUE
        set style_value $BAIT_STYLE_VALUE
    else
        set style_value black
    end

    read --command "$value" \
        (set -q _flag_password; and echo --silent) \
        --prompt "set_color $style_prompt; echo -n '$prompt'; set_color $style_value" </dev/tty
end
