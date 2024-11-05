function bait --argument-names command
    set --erase argv[1]
    switch $command
        case confirm
            tackle _bait_confirm $argv

        case choose
            tackle _bait_choose $argv

        case spin
            _bait_spin $argv

        case filter
            tacke _bait_filter $argv
    end
end
