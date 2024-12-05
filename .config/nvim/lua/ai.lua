require('avante_lib').load()

require('avante').setup({
  provider = "claude",
  --provider = "gemini",
  claude = {
    ----api_key_name = "cmd:bw get notes anthropic-api-key", -- the shell command must prefixed with `^cmd:(.*)`
    --model = "claude-3-opus-20240229",
    model = "claude-3-5-sonnet-latest",
    temperature = 0.0069,
    max_tokens = 4096,
  },
  gemini = {
    --api_key_name = "GOOGLE_API_KEY",
    model = "gemini-1.5-pro-exp-0801",
    --model = "gemini-1.5-pro-latest",
    temperature = 0.0069,
    --max_tokens = 4096,
  },
  windows = {
    position = "left",
    width = 22 -- feelin' 22
  }
  --opts = {
  --}
  --}
  --provider = "gemini_exp",
  --vendors = {
  --["gemini_exp"] = {
  --endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
  --model = "gemini-experimental",
  --timeout = 20000, -- Timeout in milliseconds (20 seconds)
  --temperature = 0,
  --max_tokens = 8192,
  --["local"] = false,
  --},
  --engi_local = {
  --endpoint = "http://127.0.0.1:3000",
  --model = "code-gemma",
  --temperature = 0,
  --max_tokens = 4096,
  --["local"] = true,
  --},
  --}
})
