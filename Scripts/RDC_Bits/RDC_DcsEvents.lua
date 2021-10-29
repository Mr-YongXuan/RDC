
RDC = RDC or {}

-- custom event and report
-- trigger on player crash eject land... report player in air time
-- attention: Non-ed-lua-engine-standard event
function RDC.inairPush(ucid, name)
    if RDC.inairTimeCount[ucid] then
        local data = {
            event = "inair_time",
            player_ucid = ucid,
            player_name = name,
            plane = RDC.inairTimeCount[ucid]["plane"],
            inair = os.time() - RDC.inairTimeCount[ucid]["inair"]
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
                event = "game_time"
            }
            timeData["player_ucid"] = RDC.playerTimeCount[k]["ucid"]
            timeData["player_name"] = RDC.playerTimeCount[k]["name"]
            timeData["total"] = os.time() - RDC.playerTimeCount[k]["stamp"]
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
            if event['player_name'] ~= '' then
                event['player_ucid'] = RDC.nameToUcid(event['player_name'])
            else
                event['player_ucid'] = ""
            end
            RDC.postData(RDC.JSON:encode(event))
            -- inair timer start
            if event['event'] == "takeoff" and event['is_ai'] == false and event['player_ucid'] ~= '' then
                RDC.inairTimeCount[event['player_ucid']] = {
                    plane = event['player_type'],
                    inair = os.time()
                }
            end

            -- inair timer stop and push
            if (event['is_ai'] == false and event['player_ucid'] ~= '')
               and (event['event'] == 'land' or event['event'] == 'crash'
               or event['event'] == 'eject' or event['pilotDead']) then
                RDC.inairPush(event['player_ucid'], event['player_name'])
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
        player_ucid = net.get_player_info(arg1, "ucid") or "",
        player_name = net.get_player_info(arg1, "name") or "AI_CONTROLLER"
    }

    if eventName == "self_kill" then
        RDC.postData(RDC.JSON:encode(data))

    elseif eventName == "connect" then
        data["player_ipaddr"] = net.get_player_info(arg1, "ipaddr")
        -- add to total time counter
        RDC.playerTimeCount[tostring(arg1)] = {
            ucid  = data["player_ucid"],
            name  = arg2,
            stamp = os.time()
        }
        RDC.postData(RDC.JSON:encode(data))
    
    elseif eventName == "disconnect" then
        data["player_ipaddr"] = net.get_player_info(arg1, "ipaddr")
        -- report the player total time
        if RDC.playerTimeCount[tostring(arg1)] ~= nil then
            local timeData = {
                event = "game_time"
            }
            -- reading ucid and player name
            timeData["player_ucid"] = RDC.playerTimeCount[tostring(arg1)]["ucid"]
            timeData["player_name"] = RDC.playerTimeCount[tostring(arg1)]["name"]
            -- fix event disconnect lost ucid and player name
            data["player_ucid"] = RDC.playerTimeCount[tostring(arg1)]["ucid"]
            data["player_name"] = RDC.playerTimeCount[tostring(arg1)]["name"]
            timeData["total"] = os.time() - RDC.playerTimeCount[tostring(arg1)]["stamp"]
            RDC.playerTimeCount[tostring(arg1)] = nil
            -- check the player inair time
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


DCS.setUserCallbacks(RDC)
RDC.info("RDC_DcsEvents.lua loaded!")