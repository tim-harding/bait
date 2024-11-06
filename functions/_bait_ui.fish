function _bait_ui --argument-names fn
    if not set -q fn
        return 1
    end

    function fish_prompt
    end
    function fish_right_prompt
    end
    function fish_mode_prompt
    end

    for key in a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 \$ \\ \* \? \~ \# \( \) \{ \} \[ \] \< \> \& \| \; \" \'
        bind $key "_bait_key $key"
    end

    bind \e\[D "_bait_key left"
    bind \e\[C "_bait_key right"
    bind \e\[A "_bait_key up"
    bind \e\[B "_bait_key down"
    bind " " "_bait_key space"
    bind \r "_bait_key enter"
    bind \t "_bait_key tab"
    bind \x7F "_bait_key backspace"
    bind \e "_bait_key escape"

    bait cursor hide
    while true
        if set -q input
            set compensate (bait cursor up (count $lines)) \
                (bait cloak show) \
                (bait cursor line-up 1)
            set lines ($fn $input)
        else
            set lines ($fn $argv[2..])
        end

        echo -es $compensate \
            (bait erase to-end) \
            (set_color normal) \
            (string join "\n" $lines)

        if set -q _bait_exit
            bait cursor show
            exit $_bait_exit
        end

        read --prompt "bait cloak hide" input
    end
end

function _bait_key
    commandline --insert $argv
    commandline --function execute
end
