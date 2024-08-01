local config = require("pomodoro.config")
local ui = require("pomodoro.ui")

---@class Pomodoro
---@field opts pomodoroOpts
---@field private state "stopped" | "started" | "break"
---@field private timer uv_timer_t?
---@field private timers_completed integer
---@field private work_started_at integer
---@field private break_started_at integer
---@field private time_break fun(self: Pomodoro):integer
---@field start_pomodoro fun(self: Pomodoro)
---@field start_break fun(self: Pomodoro)
---@field private statusline_ fun(self: Pomodoro):string
---@field private start_ fun(self: Pomodoro)
---@field private stop_ fun(self: Pomodoro)
---@field statusline fun():string
---@field start fun()
---@field stop fun()
---@field status fun()
---@field setup fun(pomodoroOpts)
local Pomodoro = {
  opts = config,
  ui = ui,
  state = "stopped",
  timer = nil,
  timers_completed = 0,
  work_started_at = 0,
  break_started_at = 0,
}

local uv = vim.uv or vim.loop

---@param duration integer
---@param start integer
---@return string|osdate
local function calc_time_remaining(duration, start)
  local seconds = duration * 60 - os.difftime(os.time(), start)
  if math.floor(seconds / 60) >= 60 then
    return os.date('!%0H:%0M:%0S', seconds)
  else
    return os.date('!%0M:%0S', seconds)
  end
end

function Pomodoro:time_break()
  if self.timers_completed == 0 then
    return self.opts.time_break_long
  else
    return self.opts.time_break_short
  end
end

function Pomodoro:start_pomodoro()
  if self.state ~= "started" then
    local work_milliseconds = self.opts.time_work * 60 * 1000
    self.timer:start(work_milliseconds, 0, vim.schedule_wrap(function() self.ui.pomodoro_completed_menu(self.opts.ui) end))
    self.work_started_at = os.time()
    self.state = "started"
  end
end

function Pomodoro:start_break()
  if self.state == "started" then
    self.timers_completed = (self.timers_completed + 1) % self.opts.timers_to_long_break
    local break_milliseconds = self:time_break() * 60 * 1000
    self.timer:start(break_milliseconds, 0, vim.schedule_wrap(function() self.ui.break_completed_menu(self.opts.ui) end))
    self.break_started_at = os.time()
    self.state = "break"
  end
end

function Pomodoro:start_()
  if self.state == "stopped" then
    self.timer = uv.new_timer()
    self:start_pomodoro()
  end
end

function Pomodoro:statusline_()
  if self.state == "stopped" then
    return self.opts.icons.stopped .. " (inactive)"
  elseif self.state == "started" then
    return self.opts.icons.started .. " " .. calc_time_remaining(self.opts.time_work, self.work_started_at)
  else
    local break_minutes = self:time_break()
    return self.opts.icons.breaking  .. " " .. calc_time_remaining(break_minutes, self.break_started_at)
  end
end

function Pomodoro:stop_()
  if self.state ~= "stopped" then
    self.timer:stop()
    self.timer:close()
    self.state = "stopped"
  end
end

Pomodoro.start = function () Pomodoro.start_(Pomodoro) end
Pomodoro.stop = function () Pomodoro.stop_(Pomodoro) end
Pomodoro.statusline = function () return Pomodoro.statusline_(Pomodoro) end
Pomodoro.status = function() vim.notify(Pomodoro.statusline(), vim.log.levels.INFO, {title = "pomodoro.nvim"}) end

local function setup_commands()
  local command_opts = {bang = false, bar = false, complete = nil}
  vim.api.nvim_create_user_command("PomodoroStart", function() Pomodoro:start() end, command_opts)
  vim.api.nvim_create_user_command("PomodoroStatus", function() Pomodoro:status() end, command_opts)
  vim.api.nvim_create_user_command("PomodoroStop", function() Pomodoro:stop() end, command_opts)
end

function Pomodoro.setup(opts)
  opts = opts or {}
  vim.tbl_deep_extend("force", Pomodoro.opts, opts)
  setup_commands()
end

return Pomodoro
