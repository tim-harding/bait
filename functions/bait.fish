function bait --argument-names command
    switch $command
        case confirm
            tackle _bait_confirm $argv[2..]

        case choose
            tackle _bait_choose $argv[2..]

        case spin
            _bait_spin $argv[2..]
    end
end
