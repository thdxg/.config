#!/usr/bin/env nu

def main [sid: string] {
    let name = $env.NAME;
    let props = [
        label="a"
    ]

    (
        sketchybar
            --set $name
            label="a"
            background.border_width=1
            background.border_color=0xff524f67
    )
}
