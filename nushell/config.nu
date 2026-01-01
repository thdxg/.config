use std/log
source completions.nu

# --- disable last login message ---
touch ~/.hushlogin

# --- paths ---
use std/util "path add"
path add /usr/local/bin/
path add /opt/homebrew/bin
$env.GOBIN = (go env GOPATH | path join bin)
path add $env.GOBIN
path add ([ $env.HOME .cargo bin ] | path join)
path add ([ $env.HOME google-cloud-sdk bin] | path join)
path add ([ $env.HOME .local bin ] | path join)
path add ([ $env.HOME .bun bin ] | path join)

# --- zellij ---
def zellij-update-tabname [] {
    if ("ZELLIJ" in $env) {
        mut tabname = "";
        mut dir: string = pwd;
        $dir = match ($dir) {
            ($env.HOME) => { "~" },
            _ => { $dir | path basename },
        };
        $tabname = $"[($dir)]";

        try {
            let cmd = (commandline | into string | split words | first);
            $tabname = ( [ $tabname " " $cmd ] | str join );
        };

        zellij action rename-tab $tabname;
    }
}

$env.config.hooks = {
    pre_prompt: [
        { $env.config.hooks.pre_prompt = [{ print "" }] },
    ],
    pre_execution: [
        { zellij-update-tabname }
    ],
    env_change: {
        PWD: [
            { zellij-update-tabname }
        ]
    }
}
