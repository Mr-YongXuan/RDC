--[[
    Project: Rabbit DCS Cloud
    Version: April (alpha version)
    Component: 动态路由->函数实现
    Copyright (C) 2021  LEO CAT
    License: GPL v3
    Sequence: 4
]]--

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
                  如你所见, 我们打通了DCS围墙!
                </div>
              </body>
            </html>
        ]]

    else response.ReturnStatus_405() end

    return response
end

RDC.info("RDC_Functions.lua loaded!")