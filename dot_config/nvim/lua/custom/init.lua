-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
local o = vim.opt
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4

-- vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", { noremap = true })

local g = vim.g

-- neovide configs
g.gui_font_default_size = 8
g.gui_font_size = vim.g.gui_font_default_size
g.gui_font_face = "JetBrainsMono:#e-antialias:#h-none"
-- g.gui_font_face = "DankMono Nerd Font Mono:#e-antialias:#h-none"
-- g.gui_font_face = "MonoLisa:#e-antialias:#h-none"
-- g.gui_font_face = "Monoid:#e-antialias:#h-full"
-- g.gui_font_face = "Hack:#e-antialias:#h-full"
-- g.gui_font_face = "InputMono Light:#e-antialias:#h-full"
g.neovide_transparency = 1
g.neovide_scroll_animation_length = 0.1
g.neovide_hide_mouse_when_typing = true
-- g.neovide_cursor_vfx_mode = "pixiedust"
g.neovide_cursor_trail_size = 0.1
g.neovide_cursor_antialiasing = true

RefreshGuiFont = function()
  o.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function()
  g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()

-- Keymaps

local fopts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<C-+>", function()
  ResizeGuiFont(1)
end, fopts)
vim.keymap.set({ "n", "i" }, "<C-->", function()
  ResizeGuiFont(-1)
end, fopts)
vim.keymap.set({ "n", "i" }, "<C-BS>", function()
  ResetGuiFont()
end, fopts)
