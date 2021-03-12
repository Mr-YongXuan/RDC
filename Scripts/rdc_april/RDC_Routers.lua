RDC = RDC or {}

RDC.Routers = {}

RDC.Routers["/"] = function(req, res)
    if req.getMethod() == "GET" then
        local body = [[
            {
                "code": 0,
                "message": "",
                "data": {
                    "name": "Rabbit DCS Cloud",
                    "version": "RDC April",
                    "website": "https://rdc.lcenter.cn",
                    "testing": "As you can see, everything is perfectly fine."
                }
            }
        ]]
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end


RDC.Routers["/server/show/status"] = function(req, res)
    local data = {
        code = 0,
        message = "",
        data = {
            status = RDC.serverStatusMachine
        }
    }

    local body = RDC.JSON:encode(data)
    res._Data = RDC.HttpBasicResponseHeaders("200 OK")
    res._Data = res._Data .. "Content-Type: application/json\r\n"
    res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
    res._Data = res._Data .. body
    return res
end


RDC.Routers["/server/show/player_list"] = function(req, res)
    if req.getMethod() == "GET" then
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
                -- stat = {
                --     crash = net.get_stat(uid, 1) or 0,
                --     car   = net.get_stat(uid, 2) or 0,
                --     plane = net.get_stat(uid, 3) or 0,
                --     ship  = net.get_stat(uid, 4) or 0,
                --     score = net.get_stat(uid, 5) or 0,
                --     land  = net.get_stat(uid, 6) or 0,
                --     eject = net.get_stat(uid, 7) or 0,
                -- },
            }
        end
        local data = {
            code = 0,
            message = "",
            data = players,
        }
        local body = RDC.JSON:encode(data)
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end


RDC.Routers["/server/control/pauses"] = function(req, res)
    if req.getMethod() == "PUT" then
        local body = {}
        if RDC.CanIAccessThis(req.getQuery("id"), req.getQuery("apisec"), 'admin') then
            DCS.setPause(true)
            body = {
                code = 0,
                message = "",
                data = {
                    state = DCS.getPause()
                }
            }
        else
            body = {
                code = -1,
                message = "You do not have the proper permissions to operate this.",
                data = "N/A"
            }
        end
        
        local body = RDC.JSON:encode(body)
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end


RDC.Routers["/server/control/resume"] = function(req, res)
    if req.getMethod() == "PUT" then
        local body = {}
        if RDC.CanIAccessThis(req.getQuery("id"), req.getQuery("apisec"), 'admin') then
            DCS.setPause(false)
            body = {
                code = 0,
                message = "",
                data = {
                    state = DCS.getPause()
                }
            }
        else
            body = {
                code = -1,
                message = "You do not have the proper permissions to operate this.",
                data = "N/A"
            }
        end
        
        local body = RDC.JSON:encode(body)
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end


RDC.Routers["/server/control/send_chat"] = function(req, res)
    if req.getMethod() == "PUT" then
        local body = {}
        if RDC.CanIAccessThis(req.getQuery("id"), req.getQuery("apisec"), 'admin') then
            local chat = req.getQuery("message")
            if chat then
                net.send_chat(chat, true)
                body = {
                    code = 0,
                    message = "",
                    data = "N/A"
                }
            else
                body = {
                    code = 1,
                    message = "There are no messages to send.",
                    data = "N/A"
                }
            end
        else
            body = {
                code = -1,
                message = "You do not have the proper permissions to operate this.",
                data = "N/A"
            }
        end
        body = RDC.JSON:encode(body)
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end


RDC.Routers["/server/control/server_reload"] = function(req, res)
    if req.getMethod() == "PUT" then
        local body = {}
        if RDC.CanIAccessThis(req.getQuery("id"), req.getQuery("apisec"), 'admin') then
            local _, err = net.dostring_in('server', 'missonReload()')
            if err then
                body = {
                    code = 0,
                    message = "",
                    data = "N/A"
                }
            else
                body = {
                    code = -1,
                    message = "unknown error!",
                    data = "N/A"
                }
            end
        else
            body = {
                code = -1,
                message = "You do not have the proper permissions to operate this.",
                data = "N/A"
            }
        end
        body = RDC.JSON:encode(body)
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end


RDC.Routers["/server/control/send_global_message_box"] = function(req, res)
    if req.getMethod() == "PUT" then
        local body = {}
        if RDC.CanIAccessThis(req.getQuery("id"), req.getQuery("apisec"), 'admin') then
            local msg = req.getQuery("message")
            local dst = req.getQuery("dst") or "10"
            local clearview = req.getQuery("cv") or "0"
            if clearview == "1" then clearview = "true" else clearview = "false" end
            if msg then
                local _, err = net.dostring_in('server', 'sendGlobalMessageBox(' .. '"' .. msg .. '",' .. dst .. ',' .. clearview .. ')')
                body = {
                    code = 0,
                    message = "",
                    data = "N/A"
                }
            else
                body = {
                    code = 1,
                    message = "There are no messages to send.",
                    data = "N/A"
                }
            end
        else
            body = {
                code = -1,
                message = "You do not have the proper permissions to operate this.",
                data = "N/A"
            }
        end
        body = RDC.JSON:encode(body)
        res._Data = RDC.HttpBasicResponseHeaders("200 OK")
        res._Data = res._Data .. "Content-Type: application/json\r\n"
        res._Data = res._Data .. "Content-Length: " .. #body .. RDC.HTTP_CONFIG.COMMON_SYBO
        res._Data = res._Data .. body
        return res
    else
        res.setReturnCode_405()
        return res
    end
end

RDC.info("SHP Routers loaded!")