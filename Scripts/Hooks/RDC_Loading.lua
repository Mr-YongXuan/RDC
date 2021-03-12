local rdcVersion = "april"

function RdcGameLoading()
    dofile(lfs.writedir() .. 'Scripts/rdc_'  .. rdcVersion .. '/RDC_Utils.lua')
    dofile(lfs.writedir() .. 'Scripts/rdc_'  .. rdcVersion .. '/RDC_Config.lua')
    dofile(lfs.writedir() .. 'Scripts/rdc_'  .. rdcVersion .. '/RDC_InGameInject.lua')
    dofile(lfs.writedir() .. 'Scripts/rdc_'  .. rdcVersion .. '/RDC_Routers.lua')
    dofile(lfs.writedir() .. 'Scripts/rdc_'  .. rdcVersion .. '/RDC_SimpleHttpProtocol.lua')
    dofile(lfs.writedir() .. 'Scripts/rdc_'  .. rdcVersion .. '/RDC_Core.lua')
end

local success, error = pcall(RdcGameLoading)

if not success then
    net.log('RDC ==> ERROR ==> error loading files, reason:' .. error)
end