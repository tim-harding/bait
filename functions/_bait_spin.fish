function _bait_spin
    for i in (seq (count $argv))
        set arg $argv[$i]
        if test $arg = --
            set subcommand_index (math "$i + 1")
            break
        end
    end

    if not set -q subcommand_index
        return
    end

    $argv[$subcommand_index..] &

    if not set pid (jobs --last --pid)
        return
    end

    function _bait_spin_handle_exit --on-process-exit $pid
        set -g _bait_spin_exited 0
    end

    bait cursor hide
    while true
        for c in ⡇ ⠏ ⠛ ⠹ ⢸ ⣰ ⣤ ⣆
            if set -q _bait_spin_exited
                break
            end
            echo -nes "$c loading..."
            bait cursor column 1
            sleep 0.03
        end
        if set -q _bait_spin_exited
            break
        end
    end
    bait cursor show
end
