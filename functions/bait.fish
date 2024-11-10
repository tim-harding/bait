function bait --argument-names command
    set --erase argv[1]
    switch $command
        case cursor
            _bait_cursor $argv
        case screen
            _bait_screen $argv
        case alternate
            _bait_alternate $argv
        case erase
            _bait_erase $argv
        case cloak
            _bait_cloak $argv
        case confirm
            _bait_confirm $argv
        case choose
            _bait_choose $argv
        case spin
            _bait_spin $argv
        case filter
            _bait_filter $argv
        case input
            _bait_input $argv
        case log
            _bait_log $argv
        case style
            _bait_style $argv
    end
end
