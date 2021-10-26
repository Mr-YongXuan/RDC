--[[
    Project: Rabbit DCS Cloud
    Version: April (alpha version)
    Component: 动态路由->路由绑定
    Copyright (C) 2021  LEO CAT
    License: GPL v3
    Sequence: 5
]]--

RDC.SHP.Routers["/"] = RDC.SHP.HandleFuns["Root"]

-- group by server read only
RDC.SHP.Routers["/server/status"] = RDC.SHP.HandleFuns["ServerStatus"]
RDC.SHP.Routers["/server/player_list"] = RDC.SHP.HandleFuns["PlayerList"]

RDC.info("RDC_Routers.lua loaded!")