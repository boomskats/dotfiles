---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>tt"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "Toggle transparency",
    },
  },

  v = {
    [">"] = { ">gv", "indent" },
  },
}

M.lspconfig = {
  n = {
    ["<leader>lr"] = {
      function()
        vim.lsp.buf.rename()
      end,
      "LSP rename",
    },
    ["<leader>ld"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "LSP definition",
    },
    ["<leader>lh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },
    ["<leader>lf"] = {
      function()
        vim.lsp.buf.references()
      end,
      "LSP references",
    },
    ["<leader>lci"] = {
      function()
        vim.lsp.buf.incoming_calls()
      end,
      "LSP incoming calls",
    },
    ["<leader>lco"] = {
      function()
        vim.lsp.buf.outgoing_calls()
      end,
      "LSP outgoing calls",
    },
    ["<leader>li"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },
    ["<leader>lI"] = {
      "<cmd> LspInfo <CR>",
      "Show LSP info",
    },
    ["<leader>lR"] = {
      "<cmd> LspStop <CR>",
      "Stop LSP",
    },
    ["<leader>lS"] = {
      "<cmd> LspStart <CR>",
      "Start LSP",
    },
    ["<leader>lD"] = {
      "<cmd> LspDiagnostics <CR>",
      "Show LSP diagnostics",
    },
    ["<leader>lA"] = {
      "<cmd> LspCodeAction <CR>",
      "Show LSP code actions",
    },
  },
}

M.structrue = {
  n = {
    ["<leader>ss"] = {
      function()
        require("structrue-go").toggle()
      end,
      "Toggle symbols outline",
    },
  },
}

M.hop = {
  n = {
    ["<leader><leader>f"] = {
      "<cmd> HopChar1<CR>",
      "Hop to char 1",
    },
    ["<leader><leader>l"] = {
      "<cmd> HopLine<CR>",
      "Hop to line",
    },
    ["<leader><leader>w"] = {
      "<cmd> HopWord<CR>",
      "Hop to word",
    },
    ["<leader><leader>s"] = {
      "<cmd> HopAnywhere<CR>",
      "Hop anywhere",
    },
  },
}

M.neotest = {
  n = {
    ["<leader>ts"] = {
      "<cmd> Neotest summary <CR>",
      "Toggle Test summary",
    },
    ["<leader>tr"] = {
      "<cmd> Neotest run <CR>",
      "Run nearest test",
    },
    ["<leader>tp"] = {
      "<cmd> Neotest output-panel <CR>",
      "Toggle output panel",
    },
  },
}

M.copilot = {
  n = {
    ["<leader>co"] = {
      function()
        local p = require "copilot.suggestion"
        p.next()
      end,
    },
  },
}

M.lazygit = {
  plugin = true,
  n = {
    ["<leader>gg"] = {
      "<cmd> LazyGit <CR>",
      "Open LazyGit floater",
      opts = {},
    },
  },
}

M.neogit = {
  plugin = true,
  n = {
    ["<leader>git"] = {
      function()
        local neogit = require "neogit"
        neogit.open()
      end,
    },
  },
}

-- more keybinds!
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>ds"] = {
      function()
        local dui = require "dapui"
        -- local widgets = require('dap.ui.widgets');
        -- local sidebar = widgets.sidebar(widgets.scopes);
        dui.toggle()
        -- sidebar.open();
      end,
      "Toggle debugging sidebar",
    },
    ["<leader>dd"] = {
      function()
        vim.api.nvim_command "write"
        local dap = require "dap"
        dap.run_last()
      end,
      "Dap run last debug",
    },
    ["<leader>dc"] = {
      function()
        vim.api.nvim_command "write"
        local dap = require "dap"
        dap.continue()
      end,
      "Dap run a debug",
    },
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
    },
    ["<leader>dgl"] = {
      function()
        require("dap-go").debug_last()
      end,
      "Debug last go test",
    },
  },
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags",
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags",
    },
  },
}

M.trouble = {
  -- plugin = true,
  n = {
    ["<leader>da"] = {
      "<cmd> TroubleToggle <CR>",
      "Toggle trouble",
    },
    ["<leader>dw"] = {
      "<cmd> Trouble workspace_diagnostics <CR>",
      "Workspace diagnostics",
    },
    ["<leader>df"] = {
      "<cmd> Trouble document_diagnostics <CR>",
      "Document diagnostics",
    },
    ["<leader>dl"] = {
      "<cmd> Trouble loclist <CR>",
      "Loclist",
    },
    ["<leader>dq"] = {
      "<cmd> Trouble quickfix <CR>",
      "Quickfix",
    },
    ["<leader>dr"] = {
      "<cmd> Trouble lsp_references <CR>",
      "References",
    },
  },
}

return M
