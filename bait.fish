function tackle
    fish --no-config --init-command "source $(status filename); _tackle_inner $argv;"
end

function _tackle_inner
    eval "function fish_prompt; end;"
    argparse "i/init=?" "u/update=" "v/view=" -- $argv

    if set -q _flag_init
        eval _flag_init
    end

    if not set -q _flag_update; or not set -q _flag_view
        echo "Expected update and view functions"
        exit
    end

    for key in \$ \\ \* \? \~ \# \( \) \{ \} \[ \] \< \> \& \| \; \" \' \a \e \f \n \r \t \v
        bind "$key" "$_flag_update $(string escape $key)"
    end

    for key in a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \ca \cb \cc \cd \ce \cf \cg \ch \ci \cj \ck \cl \cm \cn \co \cp \cq \cr \cs \ct \cu \cv \cw \cx \cy \cz
        bind $key "$_flag_update $key"
    end

    bind \e\[D "$_flag_update left"
    bind \e\[C "$_flag_update right"
    bind \e\[A "$_flag_update up"
    bind \e\[B "$_flag_update down"
    bind " " "$_flag_update space"

    bind \cC exit

    clear
    echo -ne "hello\nworld"
    _tackle_cursor_home
    _tackle_cursor_line_next 3
    _tackle_cursor_position
end

function _tackle_cursor_home -d "Moves cursor to (0,0)"
    echo -ne "\e[H"
end

function _tackle_cursor_up
    echo -nes "\e[$argv" A
end

function _tackle_cursor_down
    echo -nes "\e[$argv" B
end

function _tackle_cursor_right
    echo -nes "\e[$argv" C
end

function _tackle_cursor_left
    echo -nes "\e[$argv" D
end

function _tackle_cursor_line_next
    echo -nes "\e[$argv" E
end

function _tackle_cursor_line_previous
    echo -nes "\e[$argv" F
end

function _tackle_cursor_column
    echo -nes "\e[$argv" G
end

function _tackle_cursor_save
    echo -ne "\e[s"
end

function _tackle_cursor_restore
    echo -ne "\e[u"
end

function _tackle_cursor_hide
    echo -ne "\e[?25l"
end

function _tackle_cursor_show
    echo -ne "\e[?25h"
end

function _tackle_screen_save
    echo -ne "\e[?47l"
end

function _tackle_screen_show
    echo -ne "\e[?47h"
end

function _tackle_erase_to_end
    echo -ne "\e[0J"
end

function _tackle_erase_to_start
    echo -ne "\e[1J"
end

function _tackle_erase_all
    echo -ne "\e[2J"
end

function _tackle_erase_line_to_end
    echo -ne "\e[0K"
end

function _tackle_erase_line_to_start
    echo -ne "\e[1K"
end

function _tackle_erase_line
    echo -ne "\e[2K"
end

function _tackle_test_update
    string escape "$argv"
end

function _tackle_test_view
end
