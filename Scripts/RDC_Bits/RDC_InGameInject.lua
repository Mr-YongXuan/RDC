RDC = RDC or {}
RDC.gameInjection[#RDC.gameInjection+1] = [==[
  local RDC = RDC or {}

  ------------------------>===external packages===<------------------------
 --- split: string split function and iterator for Lua
 --
 -- Peter Aronoff
 -- BSD 3-Clause License
 -- 2012-2018
 --
 -- There are many split functions for Lua. This is mine. Though, actually,
 -- I took lots of ideas and probably some code from the implementations on
 -- the Lua-Users Wiki, http://lua-users.org/wiki/SplitJoin.
 local find = string.find
 local fmt = string.format
 local cut = string.sub
 local gmatch = string.gmatch
 local error = error
 
 --- Helper functions
 --
 -- Return a table composed of the individual characters from a string.
 local explode = function (str)
   local t = {}
   for i=1, #str do
     t[#t + 1] = cut(str, i, i)
   end
 
   return t
 end
 
 --- split(string, delimiter) => { results }
 -- Return a table composed of substrings divided by a delimiter or pattern.
 RDC.split = function (str, delimiter)
   -- Handle an edge case concerning the str parameter. Immediately return an
   -- empty table if str == ''.
   if str == '' then return {} end
 
   -- Handle special cases concerning the delimiter parameter.
   -- 1. If the pattern is nil, split on contiguous whitespace.
   -- 2. If the pattern is an empty string, explode the string.
   -- 3. Protect against patterns that match too much. Such patterns would hang
   --    the caller.
   delimiter = delimiter or '%s+'
   if delimiter == '' then return explode(str) end
   if find('', delimiter, 1) then
     local msg = fmt('The delimiter (%s) would match the empty string.',
                     delimiter)
     error(msg)
   end
 
   -- The table `t` will store the found items. `s` and `e` will keep
   -- track of the start and end of a match for the delimiter. Finally,
   -- `position` tracks where to start grabbing the next match.
   local t = {}
   local s, e
   local position = 1
   s, e = find(str, delimiter, position)
 
   while s do
     t[#t + 1] = cut(str, position, s-1)
     position = e + 1
     s, e = find(str, delimiter, position)
   end
 
   -- To get the (potential) last item, check if the final position is
   -- still within the string. If it is, grab the rest of the string into
   -- a final element.
   if position <= #str then
     t[#t + 1] = cut(str, position)
   end
 
   -- Special handling for a (potential) final trailing delimiter. If the
   -- last found end position is identical to the end of the whole string,
   -- then add a trailing empty field.
   if position > #str then
     t[#t + 1] = ''
   end
 
   return t
 end
 
 --- each(str, delimiter)
 local each = function (str, delimiter)
   delimiter = delimiter or '%s+'
   if delimiter == '' then return gmatch(str, '.') end
   if find('', delimiter, 1) then
     local msg = fmt('The delimiter (%s) would match the empty string.',
                     delimiter)
     error(msg)
   end
 
   local s, e, subsection
   local position = 1
   local iter = function ()
     if str == '' then return nil end
 
     s, e = find(str, delimiter, position)
     if s then
       subsection = cut(str, position, s-1)
       position = e + 1
       return subsection
     elseif position <= #str then
       subsection = cut(str, position)
       position = #str + 2
       return subsection
     elseif position == #str + 1 then
       position = #str + 2
       return ''
     end
   end
 
   return iter
 end
 
 local first_and_rest = function(str, delimiter)
   delimiter = delimiter or '%s+'
   if delimiter == '' then return cut(str, 1, 1), cut(str, 2) end
   if find('', delimiter, 1) then
     local msg = fmt('The delimiter (%s) would match the empty string.',
                     delimiter)
     error(msg)
   end
 
   local s, e = find(str, delimiter)
   if s then
     return cut(str, 1, s - 1), cut(str, e + 1)
   else
     return str
   end
 end
 
 RDC.eventMQ = {} -- Game event queues
 RDC.eventHandler = {}
 RDC.sameEvent = {
     groupI = {3, 4},
     groupII = {5, 6, 7, 8, 9, 14, 15, 16, 17, 18, 19, 20, 21}
 }
 RDC.hitStamp = {}
 RDC.gunsCacheMap = {}
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
         local basename = _event.place:getCallsign() or "Wilde"
         RDC.eventMQ[#RDC.eventMQ+1] = {
             event      = RDC.eventNameMap[_event.id],
             time       = _event.time,
             name       = _event.initiator:getPlayerName() or "",
             carrier    = _event.initiator:getTypeName() or "unknown",
             pilot      = _event.initiator:getName() or "unknown",
             callsign   = _event.initiator:getCallsign(),
             coalition  = _event.initiator:getCoalition(),
             basename   = basename
         }
     
     --GroupII event rebuild
     elseif RDC.strInTab(_event.id, RDC.sameEvent.groupII) then
         RDC.eventMQ[#RDC.eventMQ+1] = {
             event      = RDC.eventNameMap[_event.id],
             time       = _event.time,
             name       = _event.initiator:getPlayerName() or "",
             carrier    = _event.initiator:getTypeName() or "unknown",
             pilot      = _event.initiator:getName() or "unknown",
             callsign   = _event.initiator:getCallsign(),
             coalition  = _event.initiator:getCoalition()
         }
 
     --shot event rebuild
     elseif _event.id == 1 then
         -- 分析武器类型是否为gun shoot
         local pilotName = _event.initiator:getName()
         local weapon = _event.weapon:getTypeName() or "unknown"
         local weaponSp = RDC.split(weapon, ".")
         if #weaponSp >= 3 then -- gun shoot
             -- counts
             if not RDC.gunsCacheMap[pilotName] then
                 RDC.gunsCacheMap[pilotName] = 1
             else
                 RDC.gunsCacheMap[pilotName] = RDC.gunsCacheMap[pilotName] + 1
             end
         end
         RDC.eventMQ[#RDC.eventMQ+1] = {
             event = RDC.eventNameMap[_event.id],
             time = _event.time,
             name = _event.initiator:getPlayerName() or "",
             carrier = _event.initiator:getTypeName(),
             pilot  = pilotName,
             callsign    = _event.initiator:getCallsign(),
             coalition   = _event.initiator:getCoalition(),
             weapon_name = _event.weapon:getTypeName() or "unknown",
             weapon_type = _event.weapon:getCategory()
         }
     
     elseif _event.id == 24 then
         -- 上报机炮shot数量
         local pilotName = _event.initiator:getName()
         local weaponSp = RDC.split(_event.weapon_name, ".")
     
     --hit and kill event rebuild
     elseif _event.id == 2 or _event.id == 28 then
         local playerName = _event.initiator:getPlayerName() or ""
         -- hit interval
         if _event.id == 28 or not RDC.hitStamp[playerName] or _event.time - RDC.hitStamp[playerName] > 0.5 then
             if _event.id ~= 28 then
                 RDC.hitStamp[playerName] = _event.time
             end
             -- 取消撞机事件的上报 因性能原因
             if _event.initiator:getTypeName() ~= _event.weapon:getTypeName() then
                 RDC.eventMQ[#RDC.eventMQ+1] = {
                     event              = RDC.eventNameMap[_event.id],
                     time               = _event.time,
                     name               = playerName,
                     carrier            = _event.initiator:getTypeName() or "unknown",
                     pilot              = _event.initiator:getName() or "unknown",
                     callsign           = _event.initiator:getCallsign(),
                     coalition          = _event.initiator:getCoalition(),
                     weapon_name        = _event.weapon:getTypeName() or "unknown",
                     weapon_type        = _event.weapon:getCategory(),
                     target_name        = _event.target:getPlayerName() or "",
                     target_carrier     = _event.target:getTypeName() or "unknown",
                     target_pilot       = _event.target:getName() "unknown",
                     target_callsign    = _event.target:getCallsign(),
                     target_coalition   = _event.target:getCoalition(),
             }
             end
         end 
     end
 end
 
 
 function getNextEvent()
     if RDC.eventMQ then
         local _event = RDC.eventMQ[1]
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
 
 
 -- Moose Script Support
 function getTriggerVec2(triggerName)
     local trZone = ZONE:New( triggerName )
     return trZone:GetPointVec2()
 end
 
 
 function createStaticWithVec2(staticName, countryId, vecPos, heading)
     local Spawn = SPAWNSTATIC:NewFromStatic( staticName, countryId )
     Spawn:SpawnFromPointVec2( vecPos, heading )
 end
 
 
 function createStaticWithPos(staticName, countryId, x, y, heading)
     local Spawn = SPAWNSTATIC:NewFromStatic( staticName, countryId )
     Spawn:SpawnFromPointVec2( POINT_VEC2:New( x, y ), heading )
 end
 
 
 world.addEventHandler(RDC.eventHandler)
]==]