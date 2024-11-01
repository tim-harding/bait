function tackle
    fish --init-command "_tackle_inner $argv"
end

function _tackle_inner
    argparse "i/init=?" "u/update=" "v/view=" -- $argv

    if set -q _flag_init
        eval _flag_init
    end

    if not set -q _flag_update; or not set -q _flag_view
        echo "Expected update and view functions"
        exit
    end

    bind \e\[D "eval $_flag_update left"
    bind \e\[C "eval $_flag_update right"
    bind \e\[A "eval $_flag_update up "
    bind \e\[B "eval $_flag_update down"
end

function _tackle_test_update
    echo $argv
end

function _tackle_test_view
end
