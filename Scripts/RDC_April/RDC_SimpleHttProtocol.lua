RDC = RDC or {}

--[[
    Project: Rabbit DCS Cloud
    Version: April (alpha version)
    Component: RDC简易超文本传输服务器
    Copyright (C) 2021  LEO CAT
    License: GPL v3
    Sequence: 6
]]--

-- bind and listen a address and port
function RDC.SHP.HttpInitialSocket()
    -- bind address
    local bound, error = RDC.SHP.tcp:bind(RDC.SHP.httpConfig.listenAddr, RDC.SHP.httpConfig.listenPort)
    if not bound then
        RDC.error("Could not bind Socket: " .. error)
        return
    end

    -- listen address
    local serverStarted, error = RDC.SHP.tcp:listen(RDC.SHP.httpConfig.socketBack)
    if not serverStarted then
        RDC.error("Could not start server: " .. error)
        return
    end

    --RDC.info("Server Running at http://" .. RDC.SHP.httpConfig.listenAddr .. ":" .. RDC.SHP.httpConfig.listenPort .. "/")
end


-- currently we have no support keepalive, so close connection every time
function RDC.SHP.HttpStandardSent(resp)
    RDC.SHP.activeClient:send(resp)
    RDC.SHP.activeClient:close()
    RDC.SHP.activeClient = nil
end


-- callback with dcs server every frame
function RDC.SHP.HttpCallbackAcceptConn()
    -- try to accept a new client connection
    if not RDC.SHP.activeClient then
        RDC.SHP.tcp:settimeout(0.001)
        RDC.SHP.activeClient = RDC.SHP.tcp:accept()
    end

    -- accepted client connection
    if RDC.SHP.activeClient then
        RDC.SHP.tcp:settimeout(0)
        RDC.SHP.activeClient:settimeout(0.010)
        local data, emptyCount = "" , 0

        -- parse the request here
        local stage, keyBuf, buf = 0, "unknown", ""
        local testBuf = ""
        local request = RDC.SHP.Request:new()

        while true do
            local tmp, err = RDC.SHP.activeClient:receive(1)
             -- receive completed
             if err then break end

             testBuf = testBuf .. tmp

            if stage == 0 and tmp == " " then
              -- stage = 0 -> parse request line method
              request.Method = buf
              stage = stage + 1
              buf = ""
            
            elseif stage == 1 and tmp == " " then
              -- stage = 1 -> parse request resource and query arguments
              local _tmpBuf = RDC.split(buf, "?")
              request.Resource = _tmpBuf[1]
              if #_tmpBuf == 2 then
                for _, item in pairs(_tmpBuf[2], "&") do
                  local _tmpArgs = RDC.split(item, "=")
                  if _tmpArgs == 2 then
                    request.Arguments[_tmpArgs[1]] = _tmpArgs[2]
                  end
                end
              end
              stage = stage + 1
              buf = ""

            elseif stage == 2 and tmp == "\r" then
              -- stage = 2 -> storage http version
              request.Version = buf
              -- skip char: \n
              local _, err2 = RDC.SHP.activeClient:receive(1)
              if err2 then break end
              stage = stage + 1
              buf = ""

            elseif stage == 3 and tmp == ":" then
              -- stage = 3 && tmp = ":" -> parse request headers key
              keyBuf = buf
              -- skip char: space
              local _, err2 = RDC.SHP.activeClient:receive(1)
              if err2 then break end
              buf = ""

            elseif stage == 3 and keyBuf == "" and tmp == "\r" then
              -- stage = 3 && keyBuf = "" && tmp = "\r" -> completed

              -- skip char: \n
              local _, err2 = RDC.SHP.activeClient:receive(1)
              if err2 then break end

              stage = stage + 1
              buf = ""

            elseif stage == 3 and tmp == "\r" then
              -- stage = 3 && tmp = "\r" -> parse request headers value
              request.Arguments[keyBuf] = buf
              -- skip char: \n
              local _, err2 = RDC.SHP.activeClient:receive(1)
              if err2 then break end
              keyBuf = ""
              buf = ""

            else
              buf = buf .. tmp

            end
        end
        if buf then
          request.Body = buf 
        end

        RDC.SHP.HttpRouter(request)
    end
end


function RDC.SHP.HttpRouter(request)
  if RDC.SHP.Routers[request.Resource] then
    RDC.SHP.Response:new()
    local res = RDC.SHP.Routers[request.Resource](request, RDC.SHP.Response)
    if res.OnlyBodySentMode then
      RDC.SHP.HttpStandardSent(res.Body)

    else
      -- standard sent mode
      local body = RDC.SHP.HttpBasicResponseHeaders(res.Version .. " " .. res.Status)
      for key, val in pairs(res.Headers) do
        body = body .. key .. ": " .. val .. "\r\n"
      end

      body = body .. "\r\n" .. res.Body
      RDC.SHP.HttpStandardSent(body)
    end

    else
      RDC.SHP.HttpStandardSent(RDC.SHP.HttpClientError_404())
  end
end

RDC.SHP.HttpInitialSocket()
RDC.info("RDC_SimpleHttProtocol.lua loaded!")