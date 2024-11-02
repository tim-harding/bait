function bait
    set command $argv[1]
    switch $command
        case confirm
            tackle -i_bait_confirm_init -u_bait_confirm_update -v_bait_confirm_view
    end
end
