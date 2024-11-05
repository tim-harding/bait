function _bait_input
    argparse h/help helptext 'placeholder=?' 'prompt=?' 'value=?' 'password=?' 'header=?' -- $argv

    if set -q _flag_help
        echo -n "Usage: bait input [flags]

Prompt for some input

Flags:
  -h, --help                               Show context-sensitive help
  -v, --version                            Print the version number
      --placeholder='Type something...'    Placeholder value
      --prompt=' >'                        Prompt to display
      --value=''                           Initial value (can also be passed via stdin)
      --password                           Mask input characters
      --header=''                          Header value
      --helptext                           Show help keybinds
" &>stderr
        return
    end

    set prompt_len (string length $_flag_prompt) 0
    set prompt_len $prompt_len[1]
    set line_count 1
    set frame

    if set -q _flag_header
        set style $_bait_style_header (set_color normal)
        set -a frame $style[1] $_flag_header \n
    end

    if set -q _flag_placeholder
        set style $_bait_style_placeholder (set_color black)
        set -a frame (string repeat $prompt_len " ") $style[1] $_flag_placeholder
    end

    if set -q _flag_helptext
        set style $_bait_style_helptext (set_color normal)
        set -a frame $style[1] "\n\nenter: submit" (_tackle_cursor line-up 3)
    end

    echo -es $frame 1>&2
    read input
    if set -q _flag_helptext
        _tackle_cursor line-down 3 1>&2
        echo 1>&2
    end
    echo $input
end
