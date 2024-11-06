function _bait_input -V BAIT_STYLE_PROMPT -V BAIT_STYLE_HEADER -V BAIT_STYLE_VALUE
    argparse h/help password 'prompt=?' 'value=?' 'header=?' 'style-header=?' 'style-prompt=?' 'style-value=?' -- $argv
    or return

    if set -q _flag_help
        echo -n "Usage: bait input [flags]

Prompt for some input

Flags:
  -h, --help                     Show context-sensitive help
      --prompt='> '              Prompt to display
      --value=''                 Initial value (can also be passed via stdin)
      --header=''                Header value
      --password                 Mask input characters
      --style-header='blue -o'   set_color flags for header
      --style-prompt='black'     set_color flags for prompt
      --style-value='normal'     set_color flags for value
" &>stderr
        return
    end

    set prompt $_flag_prompt "> "
    set prompt $prompt[1]

    set -q _flag_style_prompt
    and set style_prompt $_flag_style_prompt
    or set -q BAIT_STYLE_PROMPT
    and set style_prompt $BAIT_STYLE_PROMPT
    or set style_prompt black

    set -q _flag_style_header
    and set style_header $_flag_style_header
    or set -q BAIT_STYLE_HEADER
    and set style_header $BAIT_STYLE_HEADER
    or set style_header blue -u

    set -q _flag_style_value
    and set style_value $_flag_style_value
    or set -q BAIT_STYLE_VALUE
    and set style_value $BAIT_STYLE_VALUE
    or set style_value black

    if set -q _flag_header
        set_color $style_header
        echo -es $_flag_header 1>&2
    end

    read --command "$_flag_value" \
        (set -q _flag_password; and echo --silent) \
        --prompt "set_color $style_prompt; echo -n '$prompt'; set_color $style_value" \
        input
    echo $input
end
