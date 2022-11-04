local status, tree = pcall(require, 'nvim-tree')
if not status then return end

local icons = require('icons')

tree.setup {
  disable_netrw = true,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },
  auto_reload_on_write = false,
  hijack_directories = {
    enable = false,
  },
  update_cwd = true,
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = icons.diagnostics.BoldHint,
      info = icons.diagnostics.BoldInformation,
      warning = icons.diagnostics.BoldWarning,
      error = icons.diagnostics.BoldError,
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 200,
  },
  view = {
    -- width = 40,
    adaptive_size = true,
    hide_root_folder = false,
    side = "right",
    mappings = {
      custom_only = false,
      list = {
        { key = "h", action = "dir_up" },
      }
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = icons.ui.Text,
        symlink = icons.ui.FileSymlink,
        git = {
          deleted = icons.git.FileDeleted,
          ignored = icons.git.FileIgnored,
          renamed = icons.git.FileRenamed,
          staged = icons.git.FileStaged,
          unmerged = icons.git.FileUnmerged,
          unstaged = icons.git.FileUnstaged,
          untracked = icons.git.FileUntracked,
        },
        folder = {
          default = icons.ui.Folder,
          empty = icons.ui.EmptyFolder,
          empty_open = icons.ui.EmptyFolderOpen,
          open = icons.ui.FolderOpen,
          symlink = icons.ui.FolderSymlink,
        },
      },
    },
    highlight_git = true,
    group_empty = false,
    root_folder_modifier = ":t",
  },
  filters = {
    dotfiles = false,
    custom = { "node_modules", "\\.cache" },
    exclude = {},
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
}

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>')
