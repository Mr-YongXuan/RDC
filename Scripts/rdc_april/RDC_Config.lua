RDC = RDC or {}

--[[
    Project: Rabbit DCS Cloud
    Version: April
    Component: Config - RDC全局配置存储
    Author: NatanashaKtyushaRabbit
    Created_at: 2021-02-23
    License: GPL v3
    Sequence: 2
]]--
package.path = package.path..";.\\LuaSocket\\?.lua"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll"

package.path = package.path..";.\\LuaCjson\\?.lua"
package.cpath = package.cpath..";.\\LuaCjson\\?.dll"

RDC.gameInjection = {}
RDC.serverStatusMachine = "initial"
RDC.PUSH_URL = "http://127.0.0.1/rdc/api/v1/dataPort"

RDC.HTTP_CONFIG = {
    LISTEN_ADDR = "127.0.0.1",
    LISTEN_PORT = 8099,
    SOCKET_BACK = 1024,
    COMMON_SYBO = "\r\n\r\n"
}

RDC.CORE_CONFIG = {
    HTTP_FLUSH_RATE = 10,
    DATA_PUSH_RATE = 60,
}

RDC.USER_PERMISSIONS = {
    huangsir = {
        level = "admin",
        apisec = "5216ac5bd14292e467fb069f11a1782e",
    }
}

RDC.ltn12 = require("ltn12")
RDC.http = require("http")

SHP = {}
SHP.activeClient = nil
SHP.httpServerName = "RDC"
SHP.socket = require("socket")
SHP.tcp = SHP.socket.tcp()

------------------------>===extra functions===<------------------------
-- 用户鉴权
function RDC.CanIAccessThis(uid, sec, userLevel)
    if uid and RDC.USER_PERMISSIONS[uid] and RDC.USER_PERMISSIONS[uid]["apisec"] == sec then
        if RDC.USER_PERMISSIONS[uid]["level"] == userLevel or RDC.USER_PERMISSIONS[uid]["level"] == "admin" then
            return true
        else return false end
    else return false end
end


-- 基础响应头部
function RDC.HttpBasicResponseHeaders(headerLine)
    local resp = "HTTP/1.1 " .. headerLine .. "\r\n"
    resp = resp .. "Server: " .. SHP.httpServerName .. "\r\n"
    resp = resp .. "Connection: close\r\n"
    resp = resp .. "Date: " .. os.date("%a, %d %b %Y %X GMT\r\n")
    return resp
end


-- 400 Bad Request
function RDC.HttpClientError_400()
    local body = [[
        <html>
          <head>
            <title>400 Bad Request</title>
          </head>
          <body>
            <div style="width: 100%; text-align: center;">
              <h1>400 Bad Request</h1>
              <hr />
              <span>Rabbit DCS Cloud - RDC April</span>
            </div>
          </body>
        </html>
    ]]
    local resp = RDC.HttpBasicResponseHeaders("400 Bad Request")
    resp = resp .. "Content-Type: text/html\r\n"
    resp = resp .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
    resp = resp .. body
    return resp
end


-- 404 Not Found
function RDC.HttpClientError_404()
    local body = [[
        <html>
          <head>
            <title>404 Not Found</title>
          </head>
          <body>
            <div style="width: 100%; text-align: center;">
              <h1>404 Not Found</h1>
              <hr />
              <span>Rabbit DCS Cloud - RDC April</span>
            </div>
          </body>
        </html>
    ]]
    local resp = RDC.HttpBasicResponseHeaders("404 Not Found")
    resp = resp .. "Content-Type: text/html\r\n"
    resp = resp .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
    resp = resp .. body
    return resp
end


-- 405 Method Not Allow
function RDC.HttpClientError_405()
    local body = [[
        <html>
          <head>
            <title>405 Method Not Allow</title>
          </head>
          <body>
            <div style="width: 100%; text-align: center;">
              <h1>405 Method Not Allow</h1>
              <hr />
              <span>Rabbit DCS Cloud - RDC April</span>
            </div>
          </body>
        </html>
    ]]
    local resp = RDC.HttpBasicResponseHeaders("405 Method Not Allow")
    resp = resp .. "Content-Type: text/html\r\n"
    resp = resp .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
    resp = resp .. body
    return resp
end

RDC.HttpRouterReq = {
    _Method = "",
    _QueryArgs = {},
}

function RDC.HttpRouterReq.getMethod()
    return RDC.HttpRouterReq._Method
end

function RDC.HttpRouterReq.getQuery(key)
    return RDC.HttpRouterReq._QueryArgs[key]
end

RDC.HttpRouterRes = {
    _Data = ""
}

function RDC.HttpRouterRes.setReturnCode_405()
    RDC.HttpRouterRes._Data = RDC.HttpClientError_405()
end

RDC.info("Config loaded!")