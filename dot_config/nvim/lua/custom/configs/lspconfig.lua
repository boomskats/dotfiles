local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
}

lspconfig.sqls.setup {
  on_attach = function(client, bufnr)
    require("sqls").on_attach(client, bufnr)
  end,
  root_dir = lspconfig.util.root_pattern "init.sql",
  capabilities = capabilities,
  filetypes = { "sql" },
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      gofumpt = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.volar.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "json",
  },
  init_options = {
    languageFeatures = {
      references = true,
      definition = true,
      typeDefinition = true,
      callHierarchy = true,
      hover = false,
      rename = true,
      signatureHelp = true,
      codeAction = true,
      completion = {
        defaultTagNameCase = "both",
        defaultAttrNameCase = "kebabCase",
      },
      schemaRequestService = true,
      documentHighlight = true,
      codeLens = true,
      semanticTokens = true,
      diagnostics = true,
    },
    documentFeatures = {
      selectionRange = true,
      foldingRange = true,
      linkedEditingRange = true,
      documentSymbol = true,
      documentColor = true,
    },
  },
  settings = {
    config = {
      volar = {
        completion = {
          autoImport = true,
          triggerCharacters = { ".", ":", ">" },
        },
        codeLens = {
          references = true,
          pugTools = true,
          scriptSetupTools = true,
        },
      },
    },
  },
  root_dir = lspconfig.util.root_pattern("package.json", "vue.config.js"),
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
}

-- lspconfig.pyright.setup { }
