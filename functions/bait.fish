function bait --argument-names command
    switch $command
        case confirm
            tackle _bait_confirm
    end
end
