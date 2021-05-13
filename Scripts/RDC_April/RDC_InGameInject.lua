RDC = RDC or {}
RDC.gameInjection[#RDC.gameInjection+1] = [==[
    local RDC = RDC or {}
    RDC.eventMQ = {} -- Game event queues
    RDC.eventHandler = {}
    RDC.sameEvent = {
        groupI = {3, 4},
        groupII = {5, 6, 7, 8, 9, 14, 15, 16, 17, 18, 19, 20, 21}
    }
    RDC.hitStamp = 0
    RDC.eventNameMap = {
        [1]  = "shot",
        [2]  = "hit",
        [3]  = "takeoff",
        [4]  = "land",
        [5]  = "crash",
        [6]  = "eject",
        [7]  = "refuelingStart",
        [8]  = "dead",
        [9]  = "pilotDead",
        [10] = "baseCaptured",
        [11] = "missionStart",
        [12] = "missionEnd",
        [13] = "tookControl", -- hoggit标红项
        [14] = "refuelingStop",
        [15] = "birth",
        [16] = "pilotFailure",
        [17] = "detailedFailure", -- hoggit未知项
        [18] = "engineStartup",
        [19] = "engineShutdown",
        [20] = "playerEnterUnit",
        [21] = "playerLeaveUnit",
        [23] = "shootingStart",
        [24] = "shootingEnd",
        [25] = "mark",
        [26] = "markChange",
        [27] = "markRemove",
        [28] = "kill",
        [29] = "landingAfterEjection"
    }
    
    
    function RDC.ToStringEx(value)
        if type(value) == 'table' then
            return RDC.TableToStr(value)
        elseif type(value) == 'string' then
            return "\"" .. value .. "\""
        else
            return tostring(value)
        end
    end
    
    
    function RDC.TableToStr(t)
        if t == nil then return "" end
        local retstr = "{"
    
        local i = 1
        for key, value in pairs(t) do
            local signal = ","
            if i == 1 then signal = "" end
    
            if key == i then
                retstr = retstr .. signal .. RDC.ToStringEx(value)
            else
                if type(key) == 'number' or type(key) == 'string' then
                    retstr =
                        retstr .. signal .. '[' .. RDC.ToStringEx(key) .. "]=" ..
                        RDC.ToStringEx(value)
                else
                    if type(key) == 'userdata' then
                        retstr = retstr .. signal .. "*s" ..
                        RDC.TableToStr(getmetatable(key)) .. "*e" ..
                                     "=" .. RDC.ToStringEx(value)
                    else
                        retstr = retstr .. signal .. key .. "=" ..
                        RDC.ToStringEx(value)
                    end
                end
            end
    
            i = i + 1
        end
    
        retstr = retstr .. "}"
        return retstr
    end
    function RDC.strInTab(str, tab)
        for _, v in pairs(tab) do
            if str == v then return true end
        end
    
        return false
    end
    
    
    function RDC.eventHandler:onEvent(_event)
        env.info('RDC event id : ' .. _event.id, false)
        --GroupI event rebuild
        if RDC.strInTab(_event.id, RDC.sameEvent.groupI) then
            local isAI = true
            if _event.initiator:getPlayerName() then
                isAI = false
            end
            local basename = "Wilde"
            local ok, e = pcall(function ()
                _event.place:getCallsign()
            end)
            if ok then
                basename = _event.place:getCallsign()
            end
            RDC.eventMQ[#RDC.eventMQ+1] = {
                event = RDC.eventNameMap[_event.id],
                time = _event.time,
                player_name = _event.initiator:getPlayerName() or "AI_CONTROLLER",
                is_ai       = isAI,
                player_type = _event.initiator:getTypeName(),
                pilot_name  = _event.initiator:getName(),
                callsign   = _event.initiator:getCallsign(),
                coalition  = _event.initiator:getCoalition(),
                basename   = basename
            }
        
        --GroupII event rebuild
        elseif RDC.strInTab(_event.id, RDC.sameEvent.groupII) then
            local ok, e = pcall(function ()
                _event.initiator:getPlayerName()
            end)
    
            if not ok then return end
    
            local isAI = true
            if _event.initiator:getPlayerName() then
                isAI = false
            end
            RDC.eventMQ[#RDC.eventMQ+1] = {
                event = RDC.eventNameMap[_event.id],
                time = _event.time,
                player_name = _event.initiator:getPlayerName() or "",
                is_ai       = isAI,
                player_type = _event.initiator:getTypeName(),
                pilot_name  = _event.initiator:getName(),
                callsign   = _event.initiator:getCallsign(),
                coalition  = _event.initiator:getCoalition()
            }
    
        --shot event rebuild
        elseif _event.id == 1 then
            local isAI = true
            if _event.initiator:getPlayerName() then
                isAI = false
            end
            RDC.eventMQ[#RDC.eventMQ+1] = {
                event = RDC.eventNameMap[_event.id],
                time = _event.time,
                player_name = _event.initiator:getPlayerName() or "",
                is_ai       = isAI,
                player_type = _event.initiator:getTypeName(),
                pilot_name  = _event.initiator:getName(),
                callsign    = _event.initiator:getCallsign(),
                coalition   = _event.initiator:getCoalition(),
                weapon_name = _event.weapon:getTypeName() or "unknown",
                weapon_type = _event.weapon:getCategory(),
            }
        
        --hit event rebuild
        elseif _event.id == 2 or _event.id == 29 then
            if _event.time - RDC.hitStamp > 0.5 then
                RDC.hitStamp = _event.time
                local isAI = true
                local targetIsAI = true
                local ok, e = pcall(function ()
                    _event.initiator:getPlayerName()
                end)
    
                if not ok then return end
                
                if _event.initiator:getPlayerName() then
                    isAI = false
                end
                if _event.target:getPlayerName() then
                    targetIsAI = false
                end
                -- 取消撞机事件的上报 因性能原因
                if _event.initiator:getTypeName() ~= _event.weapon:getTypeName() then
                    RDC.eventMQ[#RDC.eventMQ+1] = {
                        event = RDC.eventNameMap[_event.id],
                        time = _event.time,
                        player_name = _event.initiator:getPlayerName() or "",
                        is_ai       = isAI,
                        player_type = _event.initiator:getTypeName(),
                        pilot_name  = _event.initiator:getName(),
                        callsign    = _event.initiator:getCallsign(),
                        coalition   = _event.initiator:getCoalition(),
                        weapon_name = _event.weapon:getTypeName() or "unknown",
                        weapon_type = _event.weapon:getCategory(),
                        target_name = _event.target:getPlayerName() or "",
                        target_is_ai = targetIsAI,
                        target_type  = _event.target:getTypeName(),
                        target_pilot_name  = _event.target:getName(),
                        target_callsign    = _event.target:getCallsign(),
                        target_coalition   = _event.target:getCoalition(),
                }
                end
            end
        end
    end
    
    
    function getNextEvent()
        if RDC.eventMQ then
            _event = RDC.eventMQ[1]
            table.remove(RDC.eventMQ, 1)
            return RDC.TableToStr(_event)
        end
        return ''
    end
    
    
    function missonReload()
        trigger.action.setUserFlag(667, true)
    end
    
    
    function sendGlobalMessageBox(text, displayTime, clearview)
        trigger.action.outText(text, displayTime, clearview)
    end
    
    
    world.addEventHandler(RDC.eventHandler)
]==]