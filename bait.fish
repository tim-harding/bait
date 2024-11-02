function bait
    set command $argv[1]
    echo $command
    switch $command
        case confirm
            tackle -i_bait_confirm_init -u_bait_confirm_update -v_bait_confirm_view
    end
end

function _bait_confirm_init
    set -g _bait_state_confirm 0
    _tackle_state _bait_state_confirm
end

function _bait_confirm_update
    echo update
    if test $_bait_state_confirm -eq 0
        set _bait_state_confirm 1
    else
        set _bait_state_confirm 0
    end
end

function _bait_confirm_view
    _e "$(_tackle_style --bold -fred)Are you sure? $_tackle_epoch"
end

function _tackle_style
    # Reference:
    # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#colors--graphics-mode

    argparse 'f/foreground=?' 'b/background=?' \
        B/bold d/dim i/italic u/underline k/blinking r/reverse v/invisible s/strikethrough \
        h/help -- $argv

    _e "\e[0"

    if set -q _flag_bold
        _e ";1"
    end
    if set -q _flag_dim
        _e ";2"
    end
    if set -q _flag_italic
        _e ";3"
    end
    if set -q _flag_underline
        _e ";4"
    end
    if set -q _flag_blinking
        _e ";5"
    end
    if set -q _flag_reverse
        _e ";7"
    end
    if set -q _flag_invisible
        _e ";8"
    end
    if set -q _flag_strikethrough
        _e ";9"
    end

    if set -q _flag_foreground
        switch $_flag_foreground
            case black
                _e ";30"
            case red
                _e ";31"
            case green
                _e ";32"
            case yellow
                _e ";33"
            case blue
                _e ";34"
            case magenta
                _e ";35"
            case cyan
                _e ";36"
            case white
                _e ";37"
            case default
                _e ";39"
        end
    end

    _e m
end

function _e
    echo -nes $argv
end

function tackle
    fish --no-config --init-command \
        "source $(status filename); _tackle_inner $argv"
end

function _tackle_inner
    eval "function fish_prompt; end"
    set -g _tackle_epoch 0
    argparse "i/init=" "u/update=" "v/view=" -- $argv

    if not set -q _flag_init _flag_update _flag_view
        echo "Expected init, update, and view functions"
        exit
    end

    $_flag_init
    eval "function _tackle_update_view --on-variable _tackle_epoch; $_flag_view; end"

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
end

function _tackle_state
    for arg in $argv
        eval "function _tackle_handle_state_$arg --on-variable $arg; _tackle_epoch_increment; end"
    end
end

function _tackle_epoch_increment
    set _tackle_epoch $(math $_tackle_epoch + 1)
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
