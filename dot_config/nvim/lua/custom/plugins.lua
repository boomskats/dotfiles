local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        ft = "go",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = {
      overrides.mason,
      ensure_installed = {
        "gopls",
        "golines",
        "gofumpt",
        "goimports-reviser",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "MunifTanjim/eslint.nvim",
    lazy = false,
    ft = "javascript,typescript,typescriptreact,javascriptreact,vue",
    config = function()
      local eslint = require "eslint"
      eslint.setup {
        bin = "eslint", -- or `eslint_d`
        code_actions = {
          enable = true,
          apply_on_save = {
            enable = true,
            types = { "directive", "problem", "suggestion", "layout" },
          },
          disable_rule_comment = {
            enable = true,
            location = "separate_line", -- or `same_line`
          },
        },
        diagnostics = {
          enable = true,
          report_unused_disable_directives = false,
          run_on = "type", -- or `save`
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
      -- build debugger from source
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
    init = function()
      require("core.utils").load_mappings "dap"
      require("dap-vscode-js").setup {
        debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
        -- adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        adapters = { "pwa-chrome" },
      }
    end,
    config = function()
      for _, language in ipairs { "typescript", "javascript", "svelte", "vue" } do
        require("dap").configurations[language] = {
          {
            type = "pwa-chrome",
            name = "Launch Chrome to debug client",
            request = "launch",
            runtimeExecutable = "stable",
            runtimeArgs = { "--enable-features=UseOzonePlatform", "--ozone-platform=wayland" },
            url = "http://localhost:3000",
            sourceMaps = true,
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}",
            -- skip files from vite's hmr
            -- skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          },
          -- only if language is javascript, offer this debug action
          language == "javascript"
              and {
                -- use nvim-dap-vscode-js's pwa-node debug adapter
                type = "pwa-node",
                -- launch a new process to attach the debugger to
                request = "launch",
                -- name of the debug action you have to select for this config
                name = "Launch file in new node process",
                -- launch current file with wayland support for chrome
                runtimeExecutable = "google-chrome",
                runtimeArgs = { "--enable-features=UseOzonePlatform", "--ozone-platform=wayland" },
                program = "${file}",
                cwd = "${workspaceFolder}",
              }
            or nil,
        }
      end
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    lazy = false,
    ft = "javascript,typescript,typescriptreact,javascriptreact,vue",
  },
  {
    "microsoft/vscode-js-debug",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    lazy = false,
    ft = "javascript,typescript,typescriptreact,javascriptreact,vue",
  },
  {
    "rcarriga/nvim-dap-ui",
    init = function()
      require("dapui").setup()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open { reset = true }
      end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
  },
  {
    -- "leoluz/nvim-dap-go",
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    opts = {
      delve = {
        path = "dlv", -- Adjust to where delve is installed
      },
    },
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings "dap_go"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings "gopher"
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require("neogit").setup()
      require("core.utils").load_mappings "neogit"
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
      require("core.utils").load_mappings "lazygit"
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "top", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-\\>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup {
        prompt_func_return_type = {
          go = true,
        },
        prompt_func_param_type = {
          go = true,
        },
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-neotest/neotest-go",
      -- Your other test adapters here
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        -- your neotest config here
        adapters = {
          require "neotest-go",
        },
      }
    end,
  },
  -- { "folke/neodev.nvim", lazy = false, opts = {} },
  {
    "smoka7/hop.nvim",
    lazy = false,
    version = "*",
    opts = {},
  },
  {
    "chrisgrieser/nvim-origami",
    lazy = false,
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = {
      keepFoldsAcrossSessions = true,
    },
  },
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   lazy = false,
  --   dependencies = {
  --     "kevinhwang91/promise-async",
  --   },
  --   opts = {
  --     config = function()
  --       local capabilities = vim.lsp.protocol.make_client_capabilities()
  --       capabilities.textDocument.foldingRange = {
  --         dynamicRegistration = false,
  --         lineFoldingOnly = true,
  --       }
  --       local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
  --       for _, ls in ipairs(language_servers) do
  --         require("lspconfig")[ls].setup {
  --           capabilities = capabilities,
  --           -- you can add other fields for setting up lsp server in this table
  --         }
  --       end
  --       require("ufo").setup()
  --     end,
  --   },
  -- },
  {
    "rcarriga/nvim-notify",
    enabled = true,
    lazy = false,
    -- config = function()
    --   vim.notify = require("notify").setup { background_colour = "#000000" }
    -- end,
  },
  {
    "mrded/nvim-lsp-notify",
    enabled = true,
    lazy = false,
    requires = { "rcarriga/nvim-notify" },
    config = function()
      require("lsp-notify").setup {
        notify = require "notify",
      }
    end,
  },
  {
    "crusj/structrue-go.nvim",
    branch = "main",
  },
  -- {
  -- 	"mrjones2014/legendary.nvim",
  -- 	-- since legendary.nvim handles all your keymaps/commands,
  -- 	-- its recommended to load legendary.nvim before other plugins
  -- 	priority = 10000,
  -- 	lazy = false,
  -- 	-- sqlite is only needed if you want to use frecency sorting
  -- 	-- dependencies = { 'kkharji/sqlite.lua' }
  -- 	config = function()
  -- 		require("legendary").setup({
  -- 			lazy_nvim = { auto_register = true },
  -- 		})
  -- 	end,
  -- },
  {
    "folke/flash.nvim",
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Jump forwards",
      },
      {
        "S",
        function()
          require("flash").jump { search = { forward = false } }
        end,
        mode = { "n", "x", "o" },
        desc = "Jump backwards",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  { "miikanissi/modus-themes.nvim", lazy = false, priority = 1000 },
  {
    "VonHeikemen/fine-cmdline.nvim",
    enabled = false,
    lazy = false,
    requires = {
      { "MunifTanjim/nui.nvim" },
    },
  },
  -- { "MunifTanjim/nui.nvim", lazy = false },
  {
    "gelguy/wilder.nvim",
    lazy = false,
    enabled = false,
    config = function()
      -- require("wilder").setup()
      local wilder = require "wilder"
      wilder.setup { modes = { ":", "/", "?" } }
      -- config goes here
      wilder.set_option(
        "renderer",
        -- 	wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
        -- 		-- 'single', 'double', 'rounded' or 'solid'
        -- 		-- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
        -- 		border = "rounded",
        -- 		max_height = "75%", -- max height of the palette
        -- 		min_height = 0, -- set to the same as 'max_height' for a fixed height window
        -- 		prompt_position = "top", -- 'top' or 'bottom' to set the location of the prompt
        -- 		reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
        -- 	}))
        -- )
        -- wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_renderer(
          wilder.popupmenu_border_theme {
            highlighter = wilder.basic_highlighter(),

            highlights = {
              border = "Normal", -- highlight to use for the border
            },
            -- 'single', 'double', 'rounded' or 'solid'
            -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
            border = "rounded",
          }
          -- wilder.popupmenu_renderer({
          -- 	highlighter = {
          -- 		wilder.lua_pcre2_highlighter(), -- requires `luarocks install pcre2`
          -- 		wilder.lua_fzy_highlighter(), -- requires fzy-lua-native vim plugin found
          -- 		-- at https://github.com/romgrk/fzy-lua-native
          -- 	},
          -- 	highlights = {
          -- 		accent = wilder.make_hl(
          -- 			"WilderAccent",
          -- 			"Pmenu",
          -- 			{ { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }
          -- 		),
          -- 	},
          -- })
        )
      )
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    -- ft = "markdown",
    event = {
      "BufReadPre /home/nik/obs/**.md",
    },
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/obs",
        },
      },

      -- see below for full list of options 👇
    },
    {
      "andrewferrier/wrapping.nvim",
      lazy = false,
      config = function()
        require("wrapping").setup {
          auto_set_mode_filetype_allowlist = {
            "asciidoc",
            "gitcommit",
            "latex",
            "mail",
            "markdown",
            "rst",
            "tex",
            "text",
          },
        }
      end,
    },
  },
  {
    {
      "nvimdev/lspsaga.nvim",
      lazy = false,
      config = function()
        require("lspsaga").setup {}
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional
        "nvim-tree/nvim-web-devicons", -- optional
      },
    },
  },
  {
    "codethread/qmk.nvim",
    lazy = false,
    config = function()
      local conf = {
        name = "corneish_zen",
        variant = "zmk",
        layout = {
          "_ x x x x x x _ x x x x x x",
          "_ x x x x x x _ x x x x x x",
          "_ x x x x x x _ x x x x x x",
          "_ _ _ _ x x x _ x x x _ _ _",
        },
      }
      require("qmk").setup(conf)
    end,
  },

  {
    "folke/zen-mode.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("zen-mode").setup {
        window = {
          backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
          width = 120, -- width of the Zen window
          height = 1, -- height of the Zen window
          options = {
            signcolumn = "no", -- disable signcolumn
            number = false, -- disable number column
            relativenumber = false, -- disable relative numbers
            cursorline = false, -- disable cursorline
            cursorcolumn = false, -- disable cursor column
            foldcolumn = "0", -- disable fold column
            list = false, -- disable whitespace characters
          },
        },
        plugins = {
          gitsigns = { enabled = false }, -- disables git signs
          tmux = { enabled = false }, -- disables the tmux statusline
          twilight = { enabled = true }, -- disables the twilight plugin
        },
        on_open = function()
          vim.cmd "set foldlevel=20"
        end,
        on_close = function()
          vim.cmd "set foldlevel=0"
        end,
      }
    end,
  },
  {
    "folke/twilight.nvim",
    lazy = false,
  },
  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "ray-x/starry.nvim",
    lazy = false,
    config = function()
      require("starry").setup {

        style = {
          deep_black = true,
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = false,
    -- optional, but required for fuzzy finder support
  },
  {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    -- optional, but required for fuzzy finder support
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = false,
    config = function()
      require("telescope").load_extension "ui-select"
      require("telescope").setup {

        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}, -- even more opts } }
          },
        },
      }
    end,
  },
  {
    "nanotee/sqls.nvim",
    lazy = false,
  },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   ft = "go",
  --   opts = function()
  --     return require "custom.configs.null-ls-options"
  --   end,
  -- }

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
  --
}

return plugins
