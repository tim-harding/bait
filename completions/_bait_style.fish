set -l bait_complete complete -c _bait_style -xk

$bait_complete -f
$bait_complete -s h -l help -d "Show help"
$bait_complete -l style-border -d "Box outline styles"
$bait_complete -l style-text -d "Text styles"
$bait_complete -l margin -d "Box margins"
$bait_complete -l padding -d "Box padding"

$bait_complete -l align -d "Text alignment"
$bait_complete -l align -a "center top bottom left right"

$bait_complete -l border -d "Text box outline"
$bait_complete -l border -a block -d "████"
$bait_complete -l border -a thick-outer -d "▛▀▀▜"
$bait_complete -l border -a thick-inner -d "▗▄▄▖"
$bait_complete -l border -a double -d "╔══╗"
$bait_complete -l border -a medium -d "┏━━┓"
$bait_complete -l border -a thin -d "┌──┐"
$bait_complete -l border -a round -d "╭──╮"
