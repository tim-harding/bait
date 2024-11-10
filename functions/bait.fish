function bait --argument-names command
    set --erase argv[1]
    switch $command
        case confirm
            _bait_confirm $argv
        case choose
            _bait_choose $argv
        case spin
            _bait_spin $argv
        case input
            _bait_input $argv
        case log
            _bait_log $argv
        case style
            _bait_style $argv
    end
end
