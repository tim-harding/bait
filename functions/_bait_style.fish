function _bait_style
    if not argparse h/help 'border=?' 'align=?' 'margin=?' 'padding=?' 'style-border=?' 'style-text=?' -- $argv
        _bait_style_help
        return 1
    end

    if set -q _flag_help
        _bait_style_help
        return
    end

    if set -q _flag_style_text
        set style_text $_flag_style_text
    else if set -q BAIT_STYLE_TEXT
        set style_text $BAIT_STYLE_TEXT
    end

    if set -q _flag_style_border
        set style_border $_flag_style_border
    else if set -q BAIT_STYLE_BORDER
        set style_border $BAIT_STYLE_BORDER
    end

    set border_1 ─ ─ │ │ ╭ ╮ ╰ ╯
    set border_2 ─ ─ │ │ ┌ ┐ └ ┘
    set border_3 ━ ━ ┃ ┃ ┏ ┓ ┗ ┛
    set border_4 ═ ═ ║ ║ ╔ ╗ ╚ ╝
    set border_5 ▀ ▄ ▌ ▐ ▛ ▜ ▙ ▟
    set border_6 ▄ ▀ ▐ ▌ ▗ ▖ ▝ ▘
    set border_7 █ █ █ █ █ █ █ █

    if set -q _flag_border
        set border_kind $_flag_border
    else if set -q BAIT_BORDER
        set border_kind $BAIT_BORDER
    end

    if set -q border_kind
        switch $border_kind
            case round
                set border $border_1
            case thin
                set border $border_2
            case medium
                set border $border_3
            case double
                set border $border_4
            case thick-outer
                set border $border_5
            case thick-inner
                set border $border_6
            case block
                set border $border_7
            case '*'
                echo "Unknown border $border_kind" 1>&2
                _bait_style_help
                return 1
        end
    end

    set alignments center top bottom left right

    if set -q _flag_align
        set align_kind $_flag_align
    else if set -q BAIT_ALIGN
        set align_kind $BAIT_ALIGN
    end

    if set -q align_kind
        if contains $align_kind $alignments
            set align $align_kind
        else
            echo "Unknown alignment $align" 1>&2
            _bait_style_help
            return 1
        end
    else
        set align left
    end

    if set -q _flag_margin
        set margin $_flag_margin
    else if set -q BAIT_MARGIN
        set margin $BAIT_MARGIN
    end

    if set -q margin
        if not set margin (_bait_parse_spacing $margin)
            echo "Invalid margin" 1>&2
            _bait_style_help
            return 1
        end
    else
        set margin 0 0 0 0
    end

    if set -q _flag_padding
        set padding $_flag_padding
    else if set -q BAIT_PADDING
        set padding $BAIT_PADDING
    end

    if set -q padding
        if not set padding (_bait_parse_spacing $padding)
            echo "Invalid padding" 1>&2
            _bait_style_help
            return 1
        end
    else
        set padding 0 0 0 0
    end

    set unstyle (set_color normal)
    set margin_l (string repeat -n $margin[4] ' ')
    set padding_l (string repeat -n $padding[4] ' ')
    set padding_r (string repeat -n $padding[2] ' ')

    set line_len_max 0
    for line in $argv
        set line_len_max (math "max($line_len_max, $(string length $line))")
    end

    set lines_padded $argv
    if test $padding[1] -ge 1
        for i in (seq $padding[1])
            set --prepend lines_padded ''
        end
    end
    if test $padding[3] -ge 1
        for i in (seq $padding[3])
            set --append lines_padded ''
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
        set -a lines "$margin_l$style_border$border[3]$unstyle$padding_l$align_pad_l$style_text$line$unstyle$align_pad_r$padding_r$style_border$border[4]$unstyle"
    end

    if test $margin[1] -ge 1
        for i in (seq $margin[1])
            echo
        end
    end

    if set -q border
        set border_repeat (math $padding[2] + $padding[4] + $line_len_max)
        echo -s $margin_l $style_border $border[5] (string repeat -n $border_repeat $border[1]) $border[6] $unstyle
    end

    for line in $lines
        echo $line
    end

    if set -q border
        echo -s $margin_l $style_border $border[7] (string repeat -n $border_repeat $border[2]) $border[8] $unstyle
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
  -h, --help                      Show context-sensitive help
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
