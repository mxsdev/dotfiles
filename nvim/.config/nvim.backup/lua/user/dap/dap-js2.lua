local dap = require("dap")
local breakpoints = require("dap.breakpoints")
local dap_utils = require"dap.utils"
local api = vim.api
local uv = vim.loop

local M = {}
local sessions = {}

M.widgets = {}
-- TODO: make it hierarchical instead of flat list
M.widgets.sessions = {
  refresh_listener = "event_initialized",
  new_buf = function()
    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(buf, "buftype", "nofile")
    api.nvim_buf_set_keymap(buf, "n", "<CR>", "<Cmd>lua require('dap.ui').trigger_actions()<CR>", {})
    api.nvim_buf_set_keymap(buf, "n", "<2-LeftMouse>", "<Cmd>lua require('dap.ui').trigger_actions()<CR>", {})
    return buf
  end,
  render = function(view)
    local layer = view.layer()
    local render_session = function(session)
      local suffix
      if session.current_frame then
        suffix = "Stopped at line " .. session.current_frame.line
      elseif session.stopped_thread_id then
        suffix = "Stopped"
      else
        suffix = "Running"
      end
      local prefix = session == dap.session() and "→ " or "  "
      return prefix .. (session.config.name or "No name") .. " (" .. suffix .. ")"
    end
    local context = {}
    context.actions = {
      {
        label = "Activate session",
        fn = function(_, session)
          if session then
            require("dap").set_session(session)
            if vim.bo.bufhidden == "wipe" then
              view.close()
            else
              view.refresh()
            end
          end
        end,
      },
    }
    layer.render(vim.tbl_keys(sessions), render_session, context)
  end,
}

function M.sidebar()
  require("dap.ui.widgets").sidebar(M.widgets.sessions).open()
end

function M.ultest(cmd)
  -- https://github.com/microsoft/vscode-js-debug/issues/214#issuecomment-572686921
  return {
    dap = {
      name = "Debug Jest Tests",
      type = "pwa-node",
      request = "launch",
      runtimeArgs = cmd,
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end

local onexit_root_session = nil
local root_session = nil

-- dap.listeners.after["event_initialized"]["dap-js"] = function(session)
--   if not root_session then
--     root_session = session
--   end
-- end
--
-- dap.listeners.after["event_terminated"]["dap-js"] = function(session)
--   if session == root_session then
--     onexit_root_session()
--   end
-- end

M.variables = { }


-- for _, command in ipairs({ "next" }) do
--   dap.listeners.before[command]["dap-js"] = function(session, _, body, request)
--     M.variables[session] = nil
--   end
-- end
--
-- dap.listeners.before["variables"]["dap-js"] = function(session, _, body, request)
--   if not M.variables[session] then
--     return
--   end
--
--   for _, var in ipairs(body.variables) do
--     local info = M.variables[session][var.variablesReference]
--
--     if info and (var.evaluateName == info.evaluateName or var.name == info.name) then
--       var.value = info.value
--     end
--   end
-- end
--
-- local function set_variable_listener(session, _, body, request)
--   if not M.variables[session] then
--     M.variables[session] = { }
--   end
--
--   local key = body.variablesReference
--   local value = body.value
--
--   if not key or not value then
--     return
--   end
--   M.variables[session][key] = { value = value, evaluateName = request.expression, name = request.name }
-- end
--
-- dap.listeners.before["setVariable"]["dap-js"] = set_variable_listener
-- dap.listeners.before["setExpression"]["dap-js"] = set_variable_listener

M.breakpoints = { }

local function find_breakpoint_by_state(state)
  local bps = breakpoints.get()

  for bufnr, linebps in pairs(bps) do
    for _, bp in ipairs(linebps) do
      if bp.state == state then
        bp.bufnr = bufnr
        return bp
      end
    end
  end 
end

-- dap.listeners.before["setBreakpoints"]["dap-js"] = function(session, _, body, request)
--   for i, bp in ipairs(body.breakpoints) do
--     if not M.breakpoints[session] then
--       M.breakpoints[session] = { }
--     end
--
--     table.insert(M.breakpoints[session], bp)
--
--     if not bp.verified then
--       bp.verified = true
--       local old_message = bp.message
--       bp.message = nil
--
--       vim.defer_fn(function()
--         if not bp.verified then
--           bp.message = old_message
--
--           local bp_info = find_breakpoint_by_state(bp)
--
--           breakpoints.set_state(bp_info.bufnr, bp_info.line, bp)
--
--           if bp.message then
--             dap_utils.notify("Breakpoint rejected: " .. bp.message)
--           end
--         end
--       end, 50)
--     end
--   end 
-- end
--
-- dap.listeners.after["event_breakpoint"]["dap-js"] = function(session, body)
--   if body.reason ~= 'changed' then
--     return
--   end
--
--   local bp = body.breakpoint
--
--   if bp.id then
--     for _, xbp in ipairs(M.breakpoints[session] or {}) do
--       if xbp.id == bp.id then
--         bp.verified = xbp.verified
--       end 
--     end 
--   end
-- end

function M.connect(callback)
  local stdin = uv.new_pipe(false)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local handle, pid_or_err

  if onexit_root_session ~= nil then
    onexit_root_session()
  end

  onexit_root_session = function()
    stdin:close()
    stdout:close()
    stderr:close()
    handle:close()
    handle:kill(9)
    onexit_root_session = nil
  end

  handle, pid_or_err = uv.spawn("/opt/homebrew/bin/node", {
    args = {
      os.getenv("HOME") .. "/.local/share/nvim/site/pack/packer/start/vscode-js-debug/out/src/vsDebugServer.js",
    },
    stdio = { stdin, stdout, stderr },
    detached = true,
  }, function()
    onexit_root_session()
  end)
  assert(handle, "Error trying to get DAP pid: " .. pid_or_err)

  stdout:read_start(function(err, chunk)
    assert(not err, err)

    local port = chunk:gsub("\n", "")
    vim.schedule(function()
      callback({
        type = "server",
        host = "127.0.0.1",
        port = port,
        enrich_config = function (config, on_config)
          config.cwd = uv.cwd()
          on_config(config)
        end,
        reverse_request_handlers = {
          attachedChildSession = function(_, request)
            local body = request.arguments
            local session = nil
            session = require("dap.session"):connect(
              { host = "127.0.0.1", port = tonumber(body.config.__jsDebugChildServer) },
              {},
              function(err)
                if err then
                  vim.notify("DAP connection failed to start:" .. err, "error")
                else
                  session:initialize(body.config)
                  dap.set_session(session)
                  sessions[session] = true
                end
              end
            )
          end,
        },
      })
    end)
  end)
end

return M
