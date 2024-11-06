function _bait_erase
    switch $argv[1]
        case to-end
            echo -nes "\e[0J"
        case to-start
            echo -nes "\e[1J"
        case all
            echo -nes "\e[2J"
        case line-to-end
            echo -nes "\e[0K"
        case line-to-start
            echo -nes "\e[1K"
        case line-all
            echo -nes "\e[2K"
        case '*'
            return 1
    end
end
