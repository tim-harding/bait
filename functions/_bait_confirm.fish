function _bait_confirm --argument-names key
    if not set -q choice
        set -g choice 0
    end

    switch $key
        case left right
            set choice (math "($choice + 1) % 2")
        case y
            set -g _bait_exit 0
            return
        case n escape
            set -g _bait_exit 1
            return
        case enter
            set -g _bait_exit $choice
            return
    end

    if test $choice -eq 0
        set color_yes red
        set color_no normal
    else
        set color_yes normal
        set color_no red
    end

    echo "Are you sure?"
    set_color $color_yes --reverse
    echo -n "  YES  "
    set_color $color_no --reverse
    echo -n "  NO  "
end
