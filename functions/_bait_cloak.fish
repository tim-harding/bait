function _bait_cloak
    switch $argv[1]
        case hide
            echo -nes "\e[8m"
        case show
            echo -nes "\e[28m"
    end
end
