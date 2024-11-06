function _tackle_screen
    switch $argv[1]
        case save
            echo -ne "\e[?47h"
        case restore
            echo -ne "\e[?47l"
    end
end
