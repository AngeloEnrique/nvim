return {
  "rcarriga/nvim-dap-ui", -- Debugger UIs
  dependencies = {
    "mfussenegger/nvim-dap",  -- Debugger
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    "rcarriga/cmp-dap",
    "nvim-neotest/nvim-nio",
  },
  keys = { { "<leader>d" } },
  config = function()
    local icons = require "sixzen.icons"

    local config = {
      builtinDap = {
        breakpoint = {
          text = icons.ui.Bug,
          texthl = "DiagnosticSignError",
          linehl = "",
          numhl = "",
        },
        breakpoint_rejected = {
          text = icons.ui.Bug,
          texthl = "DiagnosticSignError",
          linehl = "",
          numhl = "",
        },
        stopped = {
          text = icons.ui.BoldArrowRight,
          texthl = "DiagnosticSignWarn",
          linehl = "Visual",
          numhl = "DiagnosticSignWarn",
        },
        ui = {
          auto_open = true,
        },
      },
    }

    local dap = require "dap"
    local dapui = require "dapui"

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require("dapui").open()
    end

    dap.configurations.java = {
      {
        name = "Debug Launch (2GB)",
        type = "java",
        request = "launch",
        vmArgs = "" .. "-Xmx2g ",
      },
      {
        name = "Debug Attach (8000)",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 8000,
      },
      {
        name = "Debug Attach (5005)",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 5005,
      },
      {
        name = "My Custom Java Run Configuration",
        type = "java",
        request = "launch",
        -- You need to extend the classPath to list your dependencies.
        -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
        -- classPaths = {},

        -- If using multi-module projects, remove otherwise.
        -- projectName = "yourProjectName",

        -- javaExec = "java",
        mainClass = "replace.with.your.fully.qualified.MainClass",

        -- If using the JDK9+ module system, this needs to be extended
        -- `nvim-jdtls` would automatically populate this property
        -- modulePaths = {},
        vmArgs = "" .. "-Xmx2g ",
      },
    }

    dapui.setup {
      expand_lines = true,
      icons = { expanded = "", collapsed = "", circular = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl",    size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,             -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    }

    require("nvim-dap-virtual-text").setup {}

    local ok_telescope, telescope = pcall(require, "telescope")
    if ok_telescope then
      telescope.load_extension "dap"
    end

    local ok_cmp, cmp = pcall(require, "cmp")
    if ok_cmp then
      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = cmp.config.sources({
          { name = "dap" },
        }, {
          { name = "buffer" },
        }),
      })
    end

    vim.fn.sign_define("DapBreakpoint", config.builtinDap.breakpoint)
    vim.fn.sign_define("DapBreakpointRejected", config.builtinDap.breakpoint_rejected)
    vim.fn.sign_define("DapStopped", config.builtinDap.stopped)

    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>db", dap.step_back)
    vim.keymap.set("n", "<leader>dc", dap.continue)
    vim.keymap.set("n", "<leader>dC", dap.run_to_cursor)
    vim.keymap.set("n", "<leader>dd", dap.disconnect)
    vim.keymap.set("n", "<leader>dq", dap.session)
    vim.keymap.set("n", "<leader>di", dap.step_into)
    vim.keymap.set("n", "<leader>do", dap.step_over)
    vim.keymap.set("n", "<leader>du", dap.step_out)
    vim.keymap.set("n", "<leader>dp", dap.pause)
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle)
    vim.keymap.set("n", "<leader>ds", dap.continue)
    vim.keymap.set("n", "<leader>dq", dap.close)
    vim.keymap.set("n", "<leader>dU", dapui.toggle)
  end,
}
