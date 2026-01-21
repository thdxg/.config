# config
$env.config.buffer_editor = "hx"
$env.config.edit_mode = 'vi'
$env.config.show_banner = false
$env.config.table.mode = "compact"
$env.config.cursor_shape.vi_normal = "block"
$env.config.cursor_shape.vi_insert = "line"
$env.config.use_kitty_protocol = true
$env.config.shell_integration = {
    osc2: true
    osc7: true
    osc8: true
}

$env.EDITOR = "hx"
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.ZELLIJ_CONFIG_DIR = ([ $env.XDG_CONFIG_HOME zellij ] | path join)

# kubeconfig
$env.KUBECONFIG = (
    [ config config-kind ]
    | reduce --fold "" { | it, acc |
        [ $acc ([$env.HOME .kube $it] | path join) ] | str join ":"
    }
)

# infisical
$env.INFISICAL_API_URL = "https://infisical.overburrow.dev"
$env.INFISICAL_PROJECT_ID = "4ff40a1f-cb8c-475a-bae5-2f6d7f0dd7f9" # ethan project

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

# lumen
$env.LUMEN_AI_PROVIDER = "gemini"
$env.LUMEN_AI_MODEL = "gemini-2.5-flash-lite"

$env.HELIX_RUNTIME = "~/dev/helix/runtime"
