function _bait_style
    if not argparse h/help 'border=' 'align=' 'margin=' 'padding=' 'style-border=' 'style-text=' -- $argv
        _bait_style_help
        return 1
    end

    if set -q _flag_help
        _bait_style_help
        return
    end

    set -q _flag_style_text
    and set -l style_text $_flag_style_text

    set -q _flag_style_border
    and set -l style_border $_flag_style_border

    set -q _flag_border
    and set -l border_kind $_flag_border

    set -q border_kind
    and set -l border
    and switch $border_kind
        case round
            set border ─ ─ │ │ ╭ ╮ ╰ ╯
        case thin
            set border ─ ─ │ │ ┌ ┐ └ ┘
        case medium
            set border ━ ━ ┃ ┃ ┏ ┓ ┗ ┛
        case double
            set border ═ ═ ║ ║ ╔ ╗ ╚ ╝
        case thick-outer
            set border ▀ ▄ ▌ ▐ ▛ ▜ ▙ ▟
        case thick-inner
            set border ▄ ▀ ▐ ▌ ▗ ▖ ▝ ▘
        case block
            set border █ █ █ █ █ █ █ █
        case '*'
            echo "Unknown border $border_kind" 1>&2
            _bait_style_help
            return 1
    end

    set -q _flag_align
    and set align_kind $_flag_align

    set -l align left
    if set -q align_kind
        if contains $align_kind center top bottom left right
            set align $align_kind
        else
            echo "Unknown alignment $align" 1>&2
            _bait_style_help
            return 1
        end
    end

    set -q _flag_margin
    and set -l margin $_flag_margin

    if set -q margin
        if not set margin (_bait_parse_spacing $margin)
            echo "Invalid margin" 1>&2
            _bait_style_help
            return 1
        end
    else
        set margin 0 0 0 0
    end

    set -q _flag_padding
    and set -l padding $_flag_padding

    if set -q padding
        if not set padding (_bait_parse_spacing $padding)
            echo "Invalid padding" 1>&2
            _bait_style_help
            return 1
        end
    else
        set padding 0 0 0 0
    end

    set -l unstyle (set_color normal)
    set -l margin_l (string repeat -n $margin[4] ' ')
    set -l padding_l (string repeat -n $padding[4] ' ')
    set -l padding_r (string repeat -n $padding[2] ' ')

    set -l line_len_max 0
    for line in $argv
        set line_len_max (math "max($line_len_max, $(string length $line))")
    end

    set -l lines_padded $argv
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

    set -l lines
    for line in $lines_padded
        set -l len_diff (math $line_len_max - (string length $line))
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

    set -l border_repeat (math $padding[2] + $padding[4] + $line_len_max)
    if set -q border
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
    echo -n "\
Usage: bait style [flags] [<text>]

Apply styling to text

Arguments:
  [<text>]   Lines of text to be styled

Flags:
  -h, --help                      Show context-sensitive help
      --border=BORDER             Border box kind
      --align=ALIGNMENT           Text alignment
      --margin=SPACING            Text margin
      --padding=SPACING           Text padding
      --style-border=SET_COLOR    Border styles
      --style-text=SET_COLOR      Text styles

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
