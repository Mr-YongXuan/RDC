RDC = RDC or {}

--[[
    Project: Rabbit DCS Cloud
    Version: April
    Component: SHP - HTTP/1.0 简单超文本传输协议
    Author: NatanashaKtyushaRabbit
    Created_at: 2021-02-23
    License: GPL v3
    Sequence: 3
    Description: 基于HTTP Version 1.1协议简单实现的HTTP服务器, 无保持连接,
                 Connection常为close, 无请求头概念, 无payload概念, 仅query参数。
]]--

function SHP.HttpInitialSocket()
    -- bind address
    local bound, error = SHP.tcp:bind(RDC.HTTP_CONFIG.LISTEN_ADDR, RDC.HTTP_CONFIG.LISTEN_PORT)
    if not bound then
        RDC.error("Could not bind Socket: " .. error)
        return
    end

    -- listen address
    local serverStarted, error = SHP.tcp:listen(RDC.HTTP_CONFIG.SOCKET_BACK)
    if not serverStarted then
        RDC.error("Could not start server: " .. error)
        return
    end
    RDC.info("Server Running at http://" .. RDC.HTTP_CONFIG.LISTEN_ADDR .. ":" .. RDC.HTTP_CONFIG.LISTEN_PORT .. "/")
end


-- 单次响应数据返回&连接结束方法
function RDC.HttpStandardSent(resp)
    SHP.activeClient:send(resp .. "\r\n")
    SHP.activeClient:close()
    SHP.activeClient = nil
end


-- HTTP事件处理 同步调用 一次仅处理一个连接的请求
function RDC.HttpHandleConnectionData(recvData)
    -- 分离头部 & 请求主体
    local splitTmp = {}
    local queryArgs = {}
    local requestHeaderLine = {}

    -- 序列 请求行信息
    splitTmp = RDC.split(recvData, " ")
    if #splitTmp ~= 3 then
        RDC.HttpStandardSent(RDC.HttpClientError_400())
        return
    end
    requestHeaderLine["Method"] = splitTmp[1]
    requestHeaderLine["Resource"] = splitTmp[2]
    requestHeaderLine["Version"] = splitTmp[3]

    -- 序列 查询参数
    if string.find(requestHeaderLine["Resource"], "?") then
        splitTmp = RDC.split(requestHeaderLine["Resource"], "?")
        requestHeaderLine["Resource"] = splitTmp[1]
        if #splitTmp >= 2 and string.find(splitTmp[2], "&") then
            local argsTmp = {}
            for _, v in pairs(RDC.split(splitTmp[2], "&")) do
                if string.find(v, "=") then
                    argsTmp = RDC.split(v, "=")
                    if #argsTmp == 2 then
                        queryArgs[argsTmp[1]] = argsTmp[2]
                    end
                end
            end
        else
            argsTmp = RDC.split(splitTmp[2], "=")
                if #argsTmp == 2 then
                    queryArgs[argsTmp[1]] = argsTmp[2]
                end
        end
    end

    if RDC.Routers[requestHeaderLine["Resource"]] then
        RDC.HttpRouterReq._Method = requestHeaderLine["Method"]
        RDC.HttpRouterReq._QueryArgs = queryArgs
        local res = RDC.Routers[requestHeaderLine["Resource"]](RDC.HttpRouterReq, RDC.HttpRouterRes)
        RDC.HttpStandardSent(res._Data)
    else
        RDC.HttpStandardSent(RDC.HttpClientError_404())
    end
end


-- 由DCS每帧驱动 循环调用 取回与服务器建立HTTP的连接
function RDC.HttpCallBackAcceptNewConnection()
    if not SHP.activeClient then
        SHP.tcp:settimeout(0.001)
        SHP.activeClient = SHP.tcp:accept()

        if SHP.activeClient then
            SHP.tcp:settimeout(0)
            local data, err = SHP.activeClient:receive()
            RDC.info(data)
            --error 常规断开连接 按照一次HTTP请求结束处理
            if err then
                SHP.activeClient:close()
                SHP.activeClient = nil
                return
            end
            --success 转交 HTTP事件处理
            RDC.HttpHandleConnectionData(data)
        end
    end
end

local success, error = pcall(SHP.HttpInitialSocket)
if not success then
    RDC.error("initial socket failed! reason:" .. error)
else
    RDC.info("SHP Server loaded!")
end

-- while true do
--     local success, error = pcall(RDC.HttpCallBackAcceptNewConnection)
--     if not success then
--         RDC.error("socket failed! reason:" .. error)
--     end
-- end