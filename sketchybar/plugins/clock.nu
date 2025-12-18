#!/usr/bin/env nu

def main [] {
    let name = $env.NAME;
    let props = [
        label=(date now | format date "%m/%d %H:%M:%S")
    ]

    sketchybar --set $name ...$props
}
