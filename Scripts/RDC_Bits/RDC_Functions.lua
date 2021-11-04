--[[
    Project: Rabbit DCS Cloud
    Version: April (alpha version)
    Component: 动态路由->函数实现
    Copyright (C) 2021  LEO CAT
    License: GPL v3
    Sequence: 4
]]--

-- home page
RDC.SHP.HandleFuns["Root"] = function (request, response)
    if request.Method == "GET" then
        response.Body = [[
            <html>
              <head>
                <meta charset="utf-8">
              </head>
              <body>
                <div style="text-align: center">
                  <h3>Welcome to RDC April</h3>
                  <hr>
                  OpenSource: <a href="https://github.com/Mr-YongXuan/RDC">Click there, just slowly push star button and say wow!~ [thx~ XD]</a>
                  <br />
                  Welcome to RDC!
                </div>
              </body>
            </html>
        ]]

    else response.ReturnStatus_405() end

    return response
end


-- show server running status
RDC.SHP.HandleFuns["ServerStatus"] = function (request, response)
  if request.Method == "GET" then
    local data = {
      code = 0,
      message = "",
      data = {
        status = RDC.serverStatusMachine
      }
    }
    response:ReturnJson(data)

  else response.ReturnStatus_405() end

  return response
end


-- show server online players
RDC.SHP.HandleFuns["PlayerList"] = function (request, response)
  if request.Method == "GET" then
    local players = {}
    for _, uid in pairs(net.get_player_list()) do
        players[#players + 1] = {
            id   = uid,
            name = net.get_player_info(uid, "name"),
            side = net.get_player_info(uid, "side"),
            slot = net.get_player_info(uid, "slot"),
            ping = net.get_player_info(uid, "ping"),
            ipaddr = net.get_player_info(uid, "ipaddr"),
            ucid = net.get_player_info(uid, "ucid"),
        }
    end
    local data = {
        code = 0,
        message = "",
        data = players,
    }
    response:ReturnJson(data)

  else response.ReturnStatus_405() end

  return response
end


-- get vec2 with mission static object
RDC.SHP.HandleFuns["SendGlobalMessage"] = function (request, response)
  if request.Method == "POST" then
    local msg = request.Body
    local tim = request.Arguments['time']
    local clv = request.Arguments['clearview']
    local res, err = net.dostring_in("server", 'sendGlobalMessageBox("' .. msg .. '",' .. tim .. ',' .. clv .. ')')
    local data = {}
    if err then
      data = {
        code = 0,
        message = "",
        data = nil
      }
    
    else
      data = {
        code = -1,
        message = res,
        data = nil
      }
    end
    
    response:ReturnJson(data)

  else response.ReturnStatus_405() end

  return response
end

RDC.info("RDC_Functions.lua loaded!")