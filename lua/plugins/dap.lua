return {
  "mfussenegger/nvim-dap",  -- Debugger
  dependencies = {
    "rcarriga/nvim-dap-ui", -- Debugger UIs
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    "rcarriga/cmp-dap",
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

    vim.fn.sign_define("DapBreakpoint", config.builtinDap.breakpoint)
    vim.fn.sign_define("DapBreakpointRejected", config.builtinDap.breakpoint_rejected)
    vim.fn.sign_define("DapStopped", config.builtinDap.stopped)

    vim.keymap.set("n", "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
    vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.step_back()<cr>")
    vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
    vim.keymap.set("n", "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>")
    vim.keymap.set("n", "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>")
    vim.keymap.set("n", "<leader>dq", "<cmd>lua require'dap'.session()<cr>")
    vim.keymap.set("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>")
    vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>")
    vim.keymap.set("n", "<leader>du", "<cmd>lua require'dap'.step_out()<cr>")
    vim.keymap.set("n", "<leader>dp", "<cmd>lua require'dap'.pause()<cr>")
    vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
    vim.keymap.set("n", "<leader>ds", "<cmd>lua require'dap'.continue()<cr>")
    vim.keymap.set("n", "<leader>dq", "<cmd>lua require'dap'.close()<cr>")
    vim.keymap.set("n", "<leader>dU", "<cmd>lua require'dapui'.toggle()<cr>")

    local dapui = require "dapui"
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
  end,
}
