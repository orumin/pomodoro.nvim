# pomodoro.nvim
A Neovim plugin written (mostly) in Lua that implements the [Pomodoro technique](https://francescocirillo.com/pages/pomodoro-technique).
This implemenation is derived from https://github.com/wthollingsworth/pomodoro.nvim

## Features
When a timer goes off, a menu is displayed to prompt you to take a break (or start the next pomodoro) with the option to stop the Pomodoro session.

![nui-menu](https://user-images.githubusercontent.com/6841638/127756757-2295395a-9a54-4b3b-82df-7dc4703a9b76.png)

When these prompts are displayed, you can also press `b` to take a break (if applicable), `p` to start the next pomodoro (if applicable), or `q` to stop the Pomodoro session.

## Requirements
* Neovim >= 0.8.0
* [A patched font](https://www.nerdfonts.com/)
* [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)

## Installation
Install the plugin with your preferred package manager.

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
require("lazy").setup({
  "JamesTeague/pomodoro.nvim",
  lazy = true
  dependencies = "MunifTanjim/nui.nvim",
  cmd = { "PomodoroStart", "PomodoroStatus", "PomodoroStop" },
  config = true
})
```

## Configuration
You can configure the length of the pomodoro, the length of a short break, the length of a long break, and the number of pomodoros that must be completed in order to take a longer break.
Also, status icon, popup menu window style and popup menu keymaps is configurable
The values shown below are the defaults.

```lua
require("pomodoro").setup({
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
})
```

## Usage
Three Ex commands are provided.

| Command         | Description                                           |
|-----------------|-------------------------------------------------------|
| :PomodoroStart  | Starts the timer.                                     |
| :PomodoroStatus | Displays the status of the timer in the message area. |
| :PomodoroStop   | Stops the Pomodoro session.                           |

### Showing the timer in the statusline
For [hoob3rt/lualine.nvim](https://github.com/hoob3rt/lualine.nvim), you can do something like:

```lua
require('lualine').setup({
  sections = {
    lualine_c = { 'filename', require('pomodoro').statusline }
  }
})
```

## Alternatives
* [mnick/vim-pomodoro](https://github.com/mnick/vim-pomodoro) and [adelarsq/vim-pomodoro](https://github.com/adelarsq/vim-pomodoro) are Vimscript plugins similar to this one with a few more bells and whistles.
* [rbong/pimodoro](https://github.com/rbong/pimodoro) is a Vimscript plugin similar to this one that encourages you to track your tasks in another file.
* [ukui00a/denops-pomodoro.vim](https://github.com/uki00a/denops-pomodoro.vim) is written in Typescript and provides desktop notifictions. 
* [mkropat/vim-tt](https://github.com/mkropat/vim-tt) allows you to implement your own task tracking method.
