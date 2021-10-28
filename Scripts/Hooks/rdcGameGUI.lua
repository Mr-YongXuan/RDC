local rdcVersion = "April"

function RdcGameLoading()
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_Config.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_Utils.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_Include.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_Functions.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_InGameInject.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_Routers.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_SimpleHttProtocol.lua')
    dofile(lfs.writedir() .. 'Scripts/RDC_'  .. rdcVersion .. '/RDC_DcsEvents.lua')
end

local success, error = pcall(RdcGameLoading)

if not success then
    net.log('RDC ==> ERROR ==> error loading files, reason:' .. error)
end