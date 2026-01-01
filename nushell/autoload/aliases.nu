alias la = ls -la
alias ll = ls -l
alias pip = pip3
alias python = python3
alias tailscale = /Applications/Tailscale.app/Contents/MacOS/Tailscale
alias zj = zellij

def conf-apps [] { ls --short-names  $env.XDG_CONFIG_HOME | get name }
# Open config files for various applications
def conf [app?: string@conf-apps] {
    mut app = $app
    if $app == null {
        $app = conf-apps | input list
    }
    if not (conf-apps | $app in $in) {
        error make --unspanned { msg: $"'($app)' not found in ($env.XDG_CONFIG_HOME)" }
    }

    let app_path = [ $env.XDG_CONFIG_HOME $app ] | path join

    ^($env.config.buffer_editor) $app_path
}

# Open instant note
def note [] {
    let note_path = [ $env.HOME note.typ ] | path join
    if not ($note_path | path exists) {
        touch $note_path
    }

    ^($env.config.buffer_editor) $note_path
}

# Explore files with yazi
def --env f [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
    		cd $cwd
    }
    rm -fp $tmp
}

def z-completion [context: string] {
    let parts = $context | str trim --left | split row " " | skip 1 | each { str downcase }
    let completions = (
        ^zoxide query --list --exclude $env.PWD -- ...$parts
            | lines
            | each { |dir|
                if ($parts | length) <= 1 {
                    $dir
                } else {
                    let dir_lower = $dir | str downcase
                    let rem_start = $parts | drop 1 | reduce --fold 0 { |part, rem_start|
                        ($dir_lower | str index-of --range $rem_start.. $part) + ($part | str length)
                    }
                    {
                        value: ($dir | str substring $rem_start..),
                        description: $dir
                    }
                }
            })
    {
        options: {
            sort: false,
            completion_algorithm: substring,
            case_sensitive: false,
        },
        completions: $completions,
    }
}

def --env --wrapped cd [...rest: string@z-completion] {
    __zoxide_z ...$rest
}

def --env secret [path?: string] {
    mut paths = $env.INFISICAL_PATHS?
    if $paths == null {
        $paths = (
            infisical secrets folders get --projectId=($env.INFISICAL_PROJECT_ID) -o json
            | from json
            | get folderName
        )
        $env.INFISICAL_PATHS = $paths
    }

    let path = "/" + ($path | default ($env.INFISICAL_PATHS | input list))

    infisical secrets --recursive --path=($path) --projectId=($env.INFISICAL_PROJECT_ID) -o json
    | from json 
    | rename key value
}
