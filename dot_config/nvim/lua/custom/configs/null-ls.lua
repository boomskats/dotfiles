local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LSPFormatting", {})

local b = null_ls.builtins

null_ls.setup {
  debug = true,
  sources = {

    -- webdev stuff
    b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
    b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "typescript", "javascript", "vue" } }, -- so prettier works only on these filetypes

    -- Lua
    b.formatting.stylua,

    -- cpp
    -- b.formatting.clang_format,

    -- golang
    null_ls.builtins.formatting.gofumpt.with { filetypes = { "go" } },
    null_ls.builtins.formatting.goimports_reviser.with { filetypes = { "go" } },
    null_ls.builtins.formatting.golines.with { filetypes = { "go" } },
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
