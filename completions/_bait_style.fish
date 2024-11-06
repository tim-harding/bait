complete -c _bait_style -f
complete -c _bait_style -s h -l help -d "Show help"
complete -c _bait_style -x -l style-border -d "Box outline styles"
complete -c _bait_style -x -l style-text -d "Text styles"
complete -c _bait_style -x -l margin -d "Box margins"
complete -c _bait_style -x -l padding -d "Box padding"

complete -c _bait_style -xk -l align -d "Text alignment"
complete -c _bait_style -xk -l align -a "center top bottom left right"

complete -c _bait_style -xk -l border -d "Text box outline"
complete -c _bait_style -xk -l border -a block -d "████"
complete -c _bait_style -xk -l border -a thick-outer -d "▛▀▀▜"
complete -c _bait_style -xk -l border -a thick-inner -d "▗▄▄▖"
complete -c _bait_style -xk -l border -a double -d "╔══╗"
complete -c _bait_style -xk -l border -a medium -d "┏━━┓"
complete -c _bait_style -xk -l border -a thin -d "┌──┐"
complete -c _bait_style -xk -l border -a round -d "╭──╮"
