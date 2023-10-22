local Menu = require('nui.menu')
local event = require('nui.utils.autocmd').event

local ui = {}

---@param pomodoro Pomodoro
function ui.pomodoro_completed_menu(pomodoro)
  local popup_options = pomodoro.opts.ui
  if not pomodoro.opt.ui.border.text.top then
    pomodoro.opt.ui.border.text.top = "[Pomodoro Completed]"
  end

  local menu_options = {
    keymap = pomodoro.opts.keymap.keymap,
    lines = { Menu.item('Take break'), Menu.item('Quit') },
    on_close = function () pomodoro:stop() end,
    on_submit = function(item)
      if item.text == 'Quit' then
        pomodoro:stop()
      else
        pomodoro:start_break()
      end
    end
  }
  local menu = Menu(popup_options, menu_options)
  menu:mount()
  menu:on(event.BufLeave, function()
    pomodoro:stop()
    menu:unmount()
  end, { once = true })
  menu:map('n', 'b', function()
    pomodoro:start_break()
    menu:unmount()
  end, { noremap = true })
  menu:map('n', 'q', function()
    pomodoro:stop()
    menu:unmount()
  end, { noremap = true })
end

---@param pomodoro Pomodoro
function ui.break_completed_menu(pomodoro)
  local popup_options = pomodoro.opts.ui
  if not pomodoro.opt.ui.border.text.top then
    pomodoro.opt.ui.border.text.top = "[Break Completed]"
  end


  local menu_options = {
    keymap = pomodoro.opts.keymap.keymap,
    lines = { Menu.item('Start pomodoro'), Menu.item('Quit') },
    on_close = function () pomodoro:stop() end,
    on_submit = function(item)
      if item.text == 'Quit' then
        pomodoro:stop()
      else
        pomodoro:start_pomodoro()
      end
    end
  }

  local menu = Menu(popup_options, menu_options)
  menu:mount()
  menu:on(event.BufLeave, function()
    pomodoro:stop()
    menu:unmount()
  end, { once = true })
  menu:map('n', 'p', function()
    pomodoro:start_pomodoro()
    menu:unmount()
  end, { noremap = true })
  menu:map('n', 'q', function()
    pomodoro:stop()
    menu:unmount()
  end, { noremap = true })
end

return ui
