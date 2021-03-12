RDC = RDC or {}
RDC.pushStart = false
RDC.playerTimeCount = {}
RDC.inairTimeCount  = {}
RDC.patrolInterval = 240
RDC.nowPatrol = 0

function RDC.inairPush(ucid, name)
    if RDC.inairTimeCount[ucid] then
        -- 同志, 请把它送上军事法庭, 我们这里处理不了。
        local data = {
            event = "inair_time",
            player_ucid = ucid,
            player_name = name,
            plane = RDC.inairTimeCount[ucid]["plane"],
            inair_second = os.time() - RDC.inairTimeCount[ucid]["inair"]
        }
        RDC.inairTimeCount[ucid] = nil
        RDC.postData(RDC.JSON:encode(data))
    end
end


function RDC.onSimulationFrame()
    local success, error = pcall(RDC.HttpCallBackAcceptNewConnection)
        if not success then
            RDC.error("HTTP server problems, reason:" .. error)
        end
    --inGameEvent提交
    if RDC.serverStatusMachine == "running" and RDC.pushStart then
        -- 事件处理 & 提交
        local _event, err = net.dostring_in('server', 'return getNextEvent()')
        if err and _event ~= '' then
            event = RDC.eval(_event)
            if event['player_name'] ~= '' then
                event['player_ucid'] = RDC.nameToUcid(event['player_name'])
            else
                event['player_ucid'] = ""
            end
            RDC.postData(RDC.JSON:encode(event))
            -- inair start判定
            if event['event'] == "takeoff" and event['is_ai'] == false and event['player_ucid'] ~= '' then
                RDC.inairTimeCount[event['player_ucid']] = {
                    plane = event['player_type'],
                    inair = os.time()
                }
            end

            -- inair end判定
            if (event['is_ai'] == false and event['player_ucid'] ~= '')
               and (event['event'] == 'land' or event['event'] == 'crash'
               or event['event'] == 'eject' or event['pilotDead']) then
                -- inair传送
                RDC.inairPush(event['player_ucid'], event['player_name'])
            end
        end

        -- 哨兵
        if RDC.nowPatrol >= RDC.patrolInterval then
            RDC.timeSentinel()
            RDC.nowPatrol = 0
        else
            RDC.nowPatrol = RDC.nowPatrol + 1
        end
    end
end


function RDC.onMissionLoadBegin()
    RDC.serverStatusMachine = "loading"
end


function RDC.onSimulationPause()
    RDC.serverStatusMachine = "pause"
end


function RDC.onSimulationResume()
    RDC.serverStatusMachine = "running"
end


function RDC.onMissionLoadEnd()
    local rs, err = net.dostring_in('server', RDC.gameInjection[1])
    if err then
        RDC.info('inGameScripts loaded!')
    else
        RDC.error('load inGameScripts! reason:' .. rs)
    end
    RDC.serverStatusMachine = "running"
    RDC.pushStart = true
end


function RDC.timeSentinel()
    -- 时间哨兵
    local onlinePlayers = net.get_player_list()
    for k, v in pairs(RDC.playerTimeCount) do
        if not RDC.valInTable(tonumber(k), onlinePlayers) then
            -- 士兵,解决掉这个麻烦的家伙!
            local timeData = {
                event = "game_time"
            }
            timeData["player_ucid"] = RDC.playerTimeCount[k]["ucid"]
            timeData["player_name"] = RDC.playerTimeCount[k]["name"]
            timeData["total_second"] = os.time() - RDC.playerTimeCount[k]["stamp"]
            RDC.playerTimeCount[k] = nil
            RDC.postData(RDC.JSON:encode(timeData))
        end
    end
end


function RDC.onGameEvent(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    local data = {
        event = eventName,
        player_ucid = net.get_player_info(arg1, "ucid") or "",
        player_name = net.get_player_info(arg1, "name") or "AI_CONTROLLER"
    }
    if eventName == "kill" then
        data["player_type"] = arg2
        data["player_side"] = arg3
        data["victim_ucid"] = net.get_player_info(arg4, "ucid") or ""
        data["victim_name"] = net.get_player_info(arg4, "name") or "AI_CONTROLLER"
        data["victim_type"] = arg5
        data["victim_side"] = arg6
        data["weapon_used"] = arg7
        if arg3 == arg6 then
            data["event"] = "firendly_kill"
        end
        RDC.postData(RDC.JSON:encode(data))

    elseif eventName == "self_kill" then
        RDC.postData(RDC.JSON:encode(data))

    elseif eventName == "connect" then
        data["player_ipaddr"] = net.get_player_info(arg1, "ipaddr")
        -- 加入到total time计时器
        RDC.playerTimeCount[tostring(arg1)] = {
            ucid  = net.get_player_info(arg1, "ucid"),
            name  = arg2,
            stamp = os.time()
        }
        RDC.postData(RDC.JSON:encode(data))
    
    elseif eventName == "disconnect" then
        data["player_ipaddr"] = net.get_player_info(arg1, "ipaddr")
        -- 上报total time计时器
        if RDC.playerTimeCount[tostring(arg1)] ~= nil then
            local timeData = {
                event = "game_time"
            }
            timeData["player_ucid"] = RDC.playerTimeCount[tostring(arg1)]["ucid"]
            timeData["player_name"] = RDC.playerTimeCount[tostring(arg1)]["name"]
            timeData["total_second"] = os.time() - RDC.playerTimeCount[tostring(arg1)]["stamp"]
            RDC.playerTimeCount[tostring(arg1)] = nil
            -- 顺手检查下是否还有没有被送去解刨的inair数据
            RDC.inairPush(timeData["player_ucid"], timeData["player_name"])
            RDC.postData(RDC.JSON:encode(timeData))
        end
        RDC.postData(RDC.JSON:encode(data))
    
    elseif eventName == "change_slot" then
        data["solt_id"] = arg2
        data["prev_side"] = arg3
        RDC.inairPush(data["player_ucid"], data["player_name"])
        RDC.postData(RDC.JSON:encode(data))
    end
end

DCS.setUserCallbacks(RDC)
RDC.info("Core loaded!")