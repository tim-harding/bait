function _tackle_cursor --argument-names command count
    switch $argv[1]
        case home
            echo -ne "\e[H"
        case save
            echo -nes "\e[s"
        case restore
            echo -nes "\e[u"
        case hide
            echo -nes "\e[?25l"
        case show
            echo -nes "\e[?25h"
    end

    if not set -q count
        return 1
    end

    if test $count -eq 0
        return
    end

    switch $argv[1]
        case up
            echo -nes "\e[$count" A
        case down
            echo -nes "\e[$count" B
        case right
            echo -nes "\e[$count" C
        case left
            echo -nes "\e[$count" D
        case line-down
            echo -nes "\e[$count" E
        case line-up
            echo -nes "\e[$count" F
        case column
            echo -nes "\e[$count" G
        case '*'
            return 1
    end
end
