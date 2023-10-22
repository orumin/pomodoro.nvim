---@class pomodoroOpts
---@field time_work integer
---@field time_break_short integer
---@field time_break_long integer
---@field timers_to_long_break integer
local opts = {
  time_work = 25,
  time_break_short = 5,
  time_break_long = 20,
  timers_to_long_break = 4,
  icons = {
    stopped = "󰚭",
    started = "󰔟",
    breaking = "󰞌",
  },
  ui = {
    border = {
      style = "rounded",
      text = {
        top_align = "left",
      },
      padding = { 1, 3 },
    },
    position = "50%",
    size = {
      width = "25%",
    },
    opacity = 1,
  },
  keymap = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>" },
    submit = { "<CR>", "<Space>" },
  }
}

return opts
