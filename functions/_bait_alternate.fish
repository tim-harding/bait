function _bait_alternate --argument-names flag
    switch $flag
        case on
            echo -nes "\e[?1049h"
        case off
            echo -nes "\e[?1049l"
        case '*'
            return 1
    end
end
