#!/usr/bin/env nu

sketchybar --add event aerospace_workspace_change

let spaces: list<string> = (aerospace list-workspaces --all | split words);
for sid in $spaces {
    let name: string = $"space.($sid)";
    let script = $"~/.config/sketchybar/plugins/aerospace.nu ($sid)"
    let click_script = $"aerospace workspace ($sid)"
    (
        sketchybar 
            --add item $name left
            --subscribe $name aerospace_workspace_change
            --set $name
            width=32
            label=($sid)
            align=center
            label.font=($env.sketchy.font):Bold:12.0
            label.color=($env.sketchy.color.secondary_fg)
            script=($script)
            click_script=($click_script)
    )
}

# spaces bracket
(
    sketchybar
        --add bracket spaces `/space\..*/`
        --set spaces
        padding_left=10
        background.color=($env.sketchy.color.primary_bg)
        background.height=32
        background.corner_radius=12
        background.border_width=2
)

(
    sketchybar 
        --add item clock right
        --set clock 
        label.font=($env.sketchy.font):Regular:14.0
        label.color=($env.sketchy.color.primary_fg)
        update_freq=1
        script="/Users/ethantlee/.config/sketchybar/plugins/clock.nu"
)
