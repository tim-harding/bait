set -l commands ui cursor screen alternate erase cloak confirm choose spin filter input log style

function _bait_complete_command --wraps complete
    complete -c bait -n "not __fish_seen_subcommand_from $commands" -k $argv
end

function _bait_complete --wraps complete --argument-names command
    complete -c bait -n "__fish_seen_subcommand_from $command" $argv[2..]
end

complete -c bait -f
_bait_complete_command -a ui -d "Run functional UI"
_bait_complete_command -a alternate -d "Toggle alternative buffer"
_bait_complete_command -a screen -d "Save and restore screen"
_bait_complete_command -a cloak -d "Hide TTY output"
_bait_complete_command -a erase -d "Erase screen contents"
_bait_complete_command -a cursor -d "Modify TTY cursor"
_bait_complete_command -a spin -d "Progress spinner"
_bait_complete_command -a log -d "Structured logging"
_bait_complete_command -a style -d "Text styling"
_bait_complete_command -a input -d "Text input form"
_bait_complete_command -a filter -d "Filtering selection UI"
_bait_complete_command -a choose -d "Option selection form"
_bait_complete_command -a confirm -d "Binary response form"

_bait_complete style -s h -l help -d "Show help"
_bait_complete style -l style-border -x -d "Box outline styles"
_bait_complete style -l style-text -x -d "Text styles"
_bait_complete style -l margin -x -d "Box margins"
_bait_complete style -l padding -x -d "Box padding"
_bait_complete style -l align -x -a "center top bottom left right" -d "Text alignment"
_bait_complete style -l border -x -a "round thin medium double thick-inner thick-outer block" -d "Text box outline"
