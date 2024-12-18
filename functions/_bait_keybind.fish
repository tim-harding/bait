function _bait_keybind
    set -q _bait_did_bind_keys
    and return

    for key in a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \cA \cB \cC \cD \cE \cF \cG \cH \cI \cJ \cK \cL \cM \cN \cO \cP \cQ \cR \cS \cT \cU \cV \cW \cX \cY \cZ 0 1 2 3 4 5 6 7 8 9 \$ \\ \* \? \~ \# \( \) \{ \} \[ \] \< \> \& \| \; \" \'
        bind -M bait $key "_bait_key $key"
    end

    for key in (bind --key-names)
        bind -M bait --key $key "_bait_key $key"
    end

    bind -M bait \e\[D "_bait_key left"
    bind -M bait \e\[C "_bait_key right"
    bind -M bait \e\[A "_bait_key up"
    bind -M bait \e\[B "_bait_key down"
    bind -M bait " " "_bait_key space"
    bind -M bait \r "_bait_key enter"
    bind -M bait \t "_bait_key tab"
    bind -M bait \e "_bait_key escape"
    bind -M bait \e\[H "_bait_key home"
    bind -M bait \e\[F "_bait_key end"

    set -g _bait_did_bind_keys
end

function _bait_key
    commandline --insert $argv
    commandline --function execute
end
