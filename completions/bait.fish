set -l commands ui cursor screen alternate erase cloak confirm choose spin filter input log style

complete -c bait -f
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a spin -d "Progress spinner"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a confirm -d "Binary response form"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a choose -d "Option selection form"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a filter -d "Filtering selection UI"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a input -d "Text input form"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a log -d "Structured logging"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a style -d "Text styling"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a ui -d "Run functional UI"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a cursor -d "Modify TTY cursor"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a screen -d "Save and restore screen"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a alternate -d "Toggle alternative buffer"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a erase -d "Erase screen contents"
complete -c bait -n "not __fish_seen_subcommand_from $commands" -a cloak -d "Hide TTY output"

complete -c bait -n "__fish_seen_subcommand_from style" -s h -l help -d "Show help"
complete -c bait -n "__fish_seen_subcommand_from style" -l border -x -a "round thin medium double thick-inner thick-outer block" -d "Text box outline"
complete -c bait -n "__fish_seen_subcommand_from style" -l align -x -a "center top bottom left right" -d "Text alignment"
complete -c bait -n "__fish_seen_subcommand_from style" -l margin -x -d "Box margins"
complete -c bait -n "__fish_seen_subcommand_from style" -l padding -x -d "Box padding"
complete -c bait -n "__fish_seen_subcommand_from style" -l style-border -x -d "Box outline styles"
complete -c bait -n "__fish_seen_subcommand_from style" -l style-text -x -d "Text styles"
