--[[
Behaviors:
- Loads Avante only when `avante_lib` and `avante` are available, then configures the OpenAI, Claude, Gemini, and Groq providers with OpenAI as the default.
- Maps `<leader>ac` to `:AvanteToggle`, leaves Avante's own auto-keymaps enabled, and makes `Avante`, `AvanteSelectedFiles`, `AvanteInput`, and `AvanteChat` buffers modifiable.
- Applies Avante-specific background and `winhighlight` overrides through `FileType`, `BufWinEnter`, and `ColorScheme` autocmds.
- Guards Avante sidebar tool-use rendering helpers so invalid result windows/buffers fail closed instead of throwing.
]]
-- =======================
-- ai.lua (Consolidated)
-- =======================
--
local keymap = vim.keymap.set
local keymap_opts = { noremap = true, silent = true }

local function map_avante(lhs, command, desc)
  keymap("n", lhs, command, vim.tbl_extend("force", keymap_opts, { desc = desc }))
end

--------------------------------------------------------------------------------
-- 1) Load Avante
--------------------------------------------------------------------------------
local has_avante_lib, avante_lib = pcall(require, "avante_lib")
if not has_avante_lib then
  return
end

avante_lib.load()

local has_avante, avante = pcall(require, "avante")
if not has_avante then
  return
end

-- By default Avante also has some auto-keymaps, but we define a mnemonic leader menu here.
map_avante("<leader>aa", "<cmd>AvanteAsk<cr>", "Avante ask")
map_avante("<leader>ab", "<cmd>AvanteBuild<cr>", "Avante build")
map_avante("<leader>ac", "<cmd>AvanteChat<cr>", "Avante chat")
map_avante("<leader>acn", "<cmd>AvanteChatNew<cr>", "Avante chat new")
map_avante("<leader>ah", "<cmd>AvanteHistory<cr>", "Avante history")
map_avante("<leader>acl", "<cmd>AvanteClear<cr>", "Avante clear")
map_avante("<leader>ae", "<cmd>AvanteEdit<cr>", "Avante edit")
map_avante("<leader>af", "<cmd>AvanteFocus<cr>", "Avante focus")
map_avante("<leader>ar", "<cmd>AvanteRefresh<cr>", "Avante refresh")
map_avante("<leader>as", "<cmd>AvanteStop<cr>", "Avante stop")
map_avante("<leader>ap", "<cmd>AvanteSwitchProvider<cr>", "Avante switch provider")
map_avante("<leader>arm", "<cmd>AvanteShowRepoMap<cr>", "Avante repo map")
map_avante("<leader>at", "<cmd>AvanteToggle<cr>", "Avante toggle")
map_avante("<leader>am", "<cmd>AvanteModels<cr>", "Avante models")
map_avante("<leader>asp", "<cmd>AvanteSwitchSelectorProvider<cr>", "Avante switch selector provider")

--------------------------------------------------------------------------------
-- 2) Make Avante buffers modifiable if needed
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante", "AvanteSelectedFiles", "AvanteInput" },
  callback = function()
    vim.bo.modifiable = true
  end,
})

--------------------------------------------------------------------------------
-- 3) Avante setup
--------------------------------------------------------------------------------
avante.setup({
  provider = "claude",
  providers = {
    claude = {
      api_key_name = "ANTHROPIC_API_KEY",
      model = "claude-4-6-sonnet",
      auth_type = "max",
    },
  },
  -- ui
  windows = {
    position = "left",
    width = 27, -- The Avante sidebar width
    input = {
      height = 18,
    }
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = true, -- default: false... hm not working?
    support_paste_from_clipboard = false,
    minimize_diff = true,                    -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true,            -- Whether to enable token counting. Default to true.
    enable_cursor_planning_mode = false,     -- Whether to enable Cursor Planning Mode. Default to false.
    enable_fastapply = true,                 -- Enable Fast Apply feature
    enable_claude_text_editor_tool_mode = true,
  },
})

do
  local ok, Sidebar = pcall(require, "avante.sidebar")
  if ok and not Sidebar._casa_tool_use_guarded then
    local original_render_tool_use_control_buttons = Sidebar.render_tool_use_control_buttons
    Sidebar.render_tool_use_control_buttons = function(self, ...)
      local result = self and self.containers and self.containers.result
      if not result or not result.winid or not result.bufnr then
        return
      end
      if not vim.api.nvim_win_is_valid(result.winid) or not vim.api.nvim_buf_is_valid(result.bufnr) then
        return
      end
      return original_render_tool_use_control_buttons(self, ...)
    end

    local original_get_current_tool_use_message_uuid = Sidebar.get_current_tool_use_message_uuid
    Sidebar.get_current_tool_use_message_uuid = function(self, ...)
      local result = self and self.containers and self.containers.result
      if not result or not result.winid then
        return nil
      end
      if not vim.api.nvim_win_is_valid(result.winid) then
        return nil
      end
      return original_get_current_tool_use_message_uuid(self, ...)
    end

    Sidebar._casa_tool_use_guarded = true
  end
end

--------------------------------------------------------------------------------
-- 4) After your Edge color scheme is set, optionally tweak floating highlights
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "edge",
  callback = function()
    -- If Avante uses "NuiSplit"/"NuiPopupBorder"/"AvanteChat" for floats/popup,
    -- these lines unify them. (Set bg, but leave fg = nil to preserve Edge text color.)
    local bg_color = "#373943"

    vim.cmd([[
      hi NuiSplit guibg=NONE ctermbg=NONE
      hi NuiPopupBorder guibg=NONE ctermbg=NONE
      hi AvanteChat guibg=NONE ctermbg=NONE
    ]])

    vim.api.nvim_set_hl(0, "NuiSplit", { bg = bg_color })
    vim.api.nvim_set_hl(0, "NuiPopupBorder", { bg = bg_color })
    vim.api.nvim_set_hl(0, "AvanteChat", { bg = bg_color })
  end,
})

--------------------------------------------------------------------------------
-- 5) Make a custom highlight group for Avante sidebars’ background:
--    We set ONLY 'bg', so text color remains from your Edge theme.
--------------------------------------------------------------------------------
vim.api.nvim_set_hl(0, "MyAvanteBg", { bg = "#373943" })

--------------------------------------------------------------------------------
-- 6) Combine FileType & BufWinEnter to ensure *all* Avante windows
--    (including "AvanteInput") actually get "MyAvanteBg".
--
--    Pattern includes:
--      - Avante (main chat)
--      - AvanteSelectedFiles (file‐select)
--      - AvanteInput (the text input)
--      - AvanteChat (popups)
--------------------------------------------------------------------------------
local function set_avante_winhl(bufnr)
  vim.schedule(function()
    local winid = vim.fn.bufwinid(bufnr)
    if winid ~= -1 then
      -- Override Normal/EndOfBuffer to get a uniform background
      vim.api.nvim_win_set_option(winid, "winhighlight", table.concat({
        "Normal:MyAvanteBg",
        "EndOfBuffer:MyAvanteBg",
        -- If you see any leftover highlights (SignColumn, CursorLine, etc.),
        -- you can add them here as well, e.g. "SignColumn:MyAvanteBg".
      }, ","))
    end
  end)
end

-- 6A) Using FileType
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante", "AvanteSelectedFiles", "AvanteInput", "AvanteChat" },
  callback = function(ctx)
    set_avante_winhl(ctx.buf)
  end,
})

-- 6B) Using BufWinEnter
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(ctx)
    local ft = vim.bo[ctx.buf].filetype
    if ft == "Avante" or ft == "AvanteSelectedFiles"
        or ft == "AvanteInput" or ft == "AvanteChat" then
      set_avante_winhl(ctx.buf)
    end
  end,
})

--------------------------------------------------------------------------------
-- 7) If Avante uses NormalFloat/FloatBorder for certain floating windows:
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "AvanteChat",
  callback = function(ctx)
    vim.schedule(function()
      local winid = vim.fn.bufwinid(ctx.buf)
      if winid ~= -1 then
        vim.api.nvim_win_set_option(winid, "winhighlight",
          "NormalFloat:MyAvanteBg,FloatBorder:MyAvanteBg"
        )
      end
    end)
  end,
})

--------------------------------------------------------------------------------
-- That’s it! Now AvanteInput, Avante, AvanteSelectedFiles, and AvanteChat
-- all share the #373943 background, leaving text color alone.
--------------------------------------------------------------------------------
