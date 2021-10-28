RDC = RDC or {}

--[[
    Project: Rabbit DCS Cloud
    Version: April (alpha version)
    Component: Config - RDC全局配置存储
    Copyright (C) 2021  LEO CAT
    License: GPL v3
    Sequence: 1
]]--


-- import LuaSocket library
package.path  = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"
RDC.socket = require("socket")
RDC.ltn12  = require("ltn12")
RDC.http   = require("http")


--[[ create & initial global variables ]]--
-- script injection into the dcs [inside of game] environment
RDC.gameInjection = {}
-- dcs server running state machine
RDC.serverStatusMachine = "initial"
-- events callback api url
RDC.pushUrl = "http://www.lcenter.cn:9000/com"
-- data push control switch
RDC.pushStart = true
RDC.playerTimeCount = {}
RDC.inairTimeCount  = {}
RDC.patrolInterval = 240
RDC.nowPatrol = 0
-- if push failed count >= 2
-- pushStatus will be change to fused state and stop push anything event to api url.
RDC.pushStatus = "normal"

--[[ RDC built-in http server ]]--
RDC.SHP = {}
RDC.SHP.Routers = {}
RDC.SHP.HandleFuns = {}
RDC.SHP.httpServerName = "RDC April/1.1.2"
RDC.SHP.tcp = RDC.socket.tcp()

-- client connection
RDC.activeClient = nil

RDC.SHP.httpConfig = {
    listenAddr = "127.0.0.1",
    listenPort = 8099,
    -- HTTP server backlog size
    socketBack = 1024
}