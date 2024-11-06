function _bait_style
    if not argparse h/help 'border=?' 'align=?' 'margin=?' 'padding=?' 'style-border=?' 'style-text=?' -- $argv
        _bait_style_help
        return 1
    end

    if set -q _flag_help
        _bait_style_help
        return
    end

    set border_1 ─ ─ │ │ ╭ ╮ ╰ ╯
    set border_2 ─ ─ │ │ ┌ ┐ └ ┘
    set border_3 ━ ━ ┃ ┃ ┏ ┓ ┗ ┛
    set border_4 ═ ═ ║ ║ ╔ ╗ ╚ ╝
    set border_5 ▀ ▄ ▌ ▐ ▛ ▜ ▙ ▟
    set border_6 ▄ ▀ ▐ ▌ ▗ ▖ ▝ ▘
    set border_7 █ █ █ █ █ █ █ █

    if set -q _flag_border
        switch $_flag_border
            case round
                set border $border_1
            case thin
                set border $border_2
            case medium
                set border $border_3
            case double
                set border $border_4
            case thick-inner
                set border $border_5
            case thick-outer
                set border $border_6
            case block
                set border $border_7
            case '*'
                _bait_style_help
                return 1
        end
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
        if not set margin (_bait_parse_spacing $_flag_margin)
            _bait_style_help
            return 1
        end
    else
        set margin 0 0 0 0
    end

    if set -q _flag_padding
        if not set padding (_bait_parse_spacing $_flag_padding)
            _bait_style_help
            return 1
        end
    else
        set padding 0 0 0 0
    end

    set margin_l (string repeat -n $margin[4] ' ')
    set padding_l (string repeat -n $padding[4] ' ')
    set padding_r (string repeat -n $padding[2] ' ')

    set line_len_max 0
    for line in $argv
        set line_len_max (math "max($line_len_max, $(string length $line))")
    end

    set padding_line (string repeat -n $line_len_max ' ')
    set lines_padded $argv
    if test $padding[1] -ge 1
        for i in (seq $padding[1])
            set --prepend lines_padded $padding_line
        end
    end
    if test $padding[3] -ge 1
        for i in (seq $padding[3])
            set --append lines_padded $padding_line
        end
    end

    for line in $lines_padded
        set len_diff (math $line_len_max - (string length $line))
        switch $align
            case left top bottom
                set align_pad_r (string repeat -n $len_diff ' ')
            case right
                set align_pad_l (string repeat -n $len_diff ' ')
            case center
                set align_pad_l (string repeat -n (math "floor($len_diff / 2)") ' ')
                set align_pad_r (string repeat -n (math "ceil($len_diff / 2)") ' ')
        end
        set -a lines "$margin_l$border[3]$padding_l$align_pad_l$line$align_pad_r$padding_r$border[4]"
    end

    if test $margin[1] -ge 1
        for i in (seq $margin[1])
            echo
        end
    end

    if set -q border
        set border_repeat (math $padding[2] + $padding[4] + $line_len_max)
        echo -s $margin_l $border[5] (string repeat -n $border_repeat $border[1]) $border[6]
    end

    for line in $lines
        echo $line
    end

    if set -q border
        echo -s $margin_l $border[7] (string repeat -n $border_repeat $border[2]) $border[8]
    end

    if test $margin[3] -ge 1
        for i in (seq $margin[3])
            echo
        end
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
  BORDER      round | thin | medium | double | thick-inner | thick-outer | block
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
