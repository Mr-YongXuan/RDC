
RDC = RDC or {}

-- custom event and report
-- trigger on player crash eject land... report player in air time
-- attention: Non-ed-lua-engine-standard event
function RDC.inairPush(ucid, name)
    if RDC.inairTimeCount[ucid] then
        local data = {
            event    = "inair_time",
            ucid     = ucid,
            name     = name,
            carrier  = RDC.inairTimeCount[ucid]["carrier"],
            count    = os.time() - RDC.inairTimeCount[ucid]["inair"]
        }
        RDC.inairTimeCount[ucid] = nil
        RDC.postData(RDC.JSON:encode(data))
    end
end


-- every RDC.patrolInterval frame, check players online status
-- if the player offline with prev patrol then push the player total seconds.
function RDC.timeSentinel()
    local onlinePlayers = net.get_player_list()
    for k, v in pairs(RDC.playerTimeCount) do
        if not RDC.valInTable(tonumber(k), onlinePlayers) then
            -- 士兵,解决掉这个麻烦的家伙!
            -- Soldier, get rid of this troublemaker!
            local timeData = {
                event = "game_time",
                ucid  =  RDC.playerTimeCount[k]["ucid"],
                name  =  RDC.playerTimeCount[k]["name"],
                count = os.time() - RDC.playerTimeCount[k]["stamp"]
            }

            RDC.playerTimeCount[k] = nil
            RDC.postData(RDC.JSON:encode(timeData))
        end
    end
end


-- trigger built-in http server transflow
-- trigger custom event report to user custom api url
function RDC.onSimulationFrame()
    local success, error = pcall(RDC.SHP.HttpCallbackAcceptConn)
        if not success then
            RDC.error("HTTP server problems, reason:" .. error)
        end
    -- mission started
    if RDC.serverStatusMachine == "running" and RDC.pushStart then
        -- fetch a event from ingame script
        local _event, err = net.dostring_in('server', 'return getNextEvent()')
        if err and _event ~= '' then
            event = RDC.eval(_event)
            event['ucid'] = ""
            if event['name'] ~= '' and event['name'] ~= 'AI_CONTROLLER' then
                event['ucid'] = RDC.nameToUcid(event['name'])
            end
            RDC.postData(RDC.JSON:encode(event))
            -- inair timer start
            if event['event'] == "takeoff" and event['ucid'] ~= '' then
                RDC.inairTimeCount[event['ucid']] = {
                    carrier = event['carrier'],
                    inair   = os.time()
                }
            end

            -- inair timer stop and push
            if event['ucid'] ~= ''
               and (event['event'] == 'land' or event['event'] == 'crash'
               or event['event'] == 'eject' or event['pilotDead']) then
                RDC.inairPush(event['ucid'], event['name'])
            end
        end

        -- Sentinel
        if RDC.nowPatrol >= RDC.patrolInterval then
            RDC.timeSentinel()
            RDC.nowPatrol = 0
        else
            RDC.nowPatrol = RDC.nowPatrol + 1
        end
    end
end


function RDC.onGameEvent(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    -- create common struct
    local data = {
        event = eventName,
        ucid = net.get_player_info(arg1, "ucid") or "",
        name = net.get_player_info(arg1, "name") or "AI_CONTROLLER"
    }

    if eventName == "self_kill" then
        RDC.postData(RDC.JSON:encode(data))

    elseif eventName == "connect" then
        data["ipaddr"] = net.get_player_info(arg1, "ipaddr")
        -- add to total time counter
        RDC.playerTimeCount[tostring(arg1)] = {
            ucid  = data["ucid"],
            name  = arg2,
            stamp = os.time()
        }
        RDC.postData(RDC.JSON:encode(data))
    
    elseif eventName == "disconnect" then
        data["ipaddr"] = net.get_player_info(arg1, "ipaddr")
        -- report the player total time
        if RDC.playerTimeCount[tostring(arg1)] ~= nil then
            local timeData = {
                event = "game_time",
                ucid  = RDC.playerTimeCount[tostring(arg1)]["ucid"],
                name  = RDC.playerTimeCount[tostring(arg1)]["name"],
                count = os.time() - RDC.playerTimeCount[tostring(arg1)]["stamp"]
            }
            -- fix event disconnect lost ucid and player name
            data["ucid"] = RDC.playerTimeCount[tostring(arg1)]["ucid"]
            data["name"] = RDC.playerTimeCount[tostring(arg1)]["name"]
            RDC.playerTimeCount[tostring(arg1)] = nil
            -- check the player inair time
            RDC.inairPush(timeData["ucid"], timeData["name"])
            RDC.postData(RDC.JSON:encode(timeData))
        end
        RDC.postData(RDC.JSON:encode(data))
    
    elseif eventName == "change_slot" then
        data["solt_id"] = arg2
        data["prev_side"] = arg3
        RDC.inairPush(data["ucid"], data["name"])
        RDC.postData(RDC.JSON:encode(data))
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
    rs, err = net.dostring_in('server', RDC.gameInjection[1])
    if err then
        RDC.info('inGameScript-RDC loaded!')
    else
        RDC.error('load inGameScripts! reason:' .. rs)
    end
    RDC.serverStatusMachine = "running"
    RDC.pushStart = true
end


function onPlayerTrySendChat(playerID, msg, all)
    local data = {
        event = "chat",
        player_ucid = net.get_player_info(playerID, "ucid") or "",
        player_name = net.get_player_info(playerID, "name") or "AI_CONTROLLER",
        message = msg,
        send_all = all
    }
    local res = RDC.postData(RDC.JSON:encode(data))
    if res ~= "RDC_BLOCK_MSG" then
        return msg
    end
    return ''
end

DCS.setUserCallbacks(RDC)
RDC.info("RDC_DcsEvents.lua loaded!")