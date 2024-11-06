function _bait_style
    if not argparse h/help 'border=?' 'align=?' 'margin=?' 'padding=?' 'style-border=?' 'style-text=?' -- $argv
        _bait_style_help
        return 1
    end

    if set -q _flag_help
        _bait_style_help
        return
    end

    set borders none round thin medium double thick-inner thick-outer block

    set border_0 " " " " " " " " " " " "
    set border_1 ─ ─ │ │ ┌ ┐ └ ┘
    set border_2 ─ ─ │ │ ╭ ╮ ╰ ╯
    set border_3 ━ ━ ┃ ┃ ┏ ┓ ┗ ┛
    set border_4 ═ ═ ║ ║ ╔ ╗ ╚ ╝
    set border_5 ▀ ▄ ▌ ▐ ▛ ▜ ▙ ▟
    set border_6 ▄ ▀ ▐ ▌ ▗ ▖ ▝ ▘
    set border_7 █ █ █ █ █ █ █ █

    if set -q _flag_border
        if contains $_flag_border $borders
            set border $_flag_border
        else
            _bait_style_help
            return 1
        end
    else
        set border none
    end

    set alignments center top bottom left right

    if set -q _flag_align
        if contains $_flag_align $alignments
            set align $_flag_align
        else
            _bait_style_help
            return 1
        end
    else
        set align left
    end

    if set -q _flag_margin
        if not set margins (_bait_parse_spacing $_flag_margin)
            _bait_style_help
            return 1
        end
    else
        set margins 0 0 0 0
    end

    if set -q _flag_padding
        if not set paddings (_bait_parse_spacing $_flag_padding)
            _bait_style_help
            return 1
        end
    else
        set paddings 0 0 0 0
    end

    set line_len_max 0
    for line in $argv
        set line_len_max (math "max($line_len_max, $(string length $line))")
    end
    echo $line_len_max

    for line in $argv
        echo $line
    end
end

function _bait_style_help
    echo -n "Usage: bait style [flags] [<text>]

Apply styling to text

Arguments:
  [<text>]   Lines of text to be styled

Flags:
  -h, --help                      Show context-sensitive help.
      --border=BORDER             Border box kind (or BAIT_BORDER)
      --align=ALIGNMENT           Text alignment  (or BAIT_ALIGN)
      --margin=SPACING            Text margin     (or BAIT_MARGIN)
      --padding=SPACING           Text padding    (or BAIT_PADDING)
      --style-border=SET_COLOR    Border styles   (or BAIT_STYLE_BORDER)
      --style-text=SET_COLOR      Text styles     (or BAIT_STYLE_TEXT)

Arguments:
  BORDER      none | round | thin | medium | double | thick-inner | thick-outer | block
  ALIGNMENT   center | top | bottom | left | right
  SPACING     \$top \$right \$bottom \$left |
              \$vertical \$horizontal |
              \$all
  SET_COLOR   Styling to apply, creating using `set_color`
" 1>&2
end

function _bait_parse_spacing
    if set groups (string match --regex "^(\d+) (\d+) (\d+) (\d+)\$" $argv)
        echo $groups[2]
        echo $groups[3]
        echo $groups[4]
        echo $groups[5]
    else if set groups (string match --regex "^(\d+) (\d+)\$" $argv)
        echo $groups[2]
        echo $groups[3]
        echo $groups[2]
        echo $groups[3]
    else if set groups (string match --regex "^(\d+)\$" $argv)
        echo $groups[2]
        echo $groups[2]
        echo $groups[2]
        echo $groups[2]
    else
        return 1
    end
end
