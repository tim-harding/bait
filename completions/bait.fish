set -l commands ui cursor screen alternate erase cloak confirm choose spin filter input log style
set -l bait_complete complete -c bait -n "not __fish_seen_subcommand_from $commands" -k $argv

complete -c bait -f
$bait_complete -a ui -d "Run functional UI"
$bait_complete -a alternate -d "Toggle alternative buffer"
$bait_complete -a screen -d "Save and restore screen"
$bait_complete -a cloak -d "Hide TTY output"
$bait_complete -a erase -d "Erase screen contents"
$bait_complete -a cursor -d "Modify TTY cursor"
$bait_complete -a spin -d "Progress spinner"
$bait_complete -a log -d "Structured logging"
$bait_complete -a style -d "Text styling"
$bait_complete -a input -d "Text input form"
$bait_complete -a filter -d "Filtering selection UI"
$bait_complete -a choose -d "Option selection form"
$bait_complete -a confirm -d "Binary response form"

complete -c bait -n "__fish_seen_subcommand_from style" --wraps _bait_style
