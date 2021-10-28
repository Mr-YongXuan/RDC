-- LotAtc callbacks
net.log('[LOTATC] GameGUI loading...')


-- LotAtc
do
  local atc_loader_path = lfs.writedir() .. 'Mods\\services\\LotAtc\\'
  local f = io.open( atc_loader_path .. 'lua\\lotatc_server.lua', 'r')
  if f then
    net.log("[LOTATC] LotAtc Mod found, load it")
    f:close()
    dofile(atc_loader_path .. 'lua\\lotatc_config.lua')
    lotatc_inst.loader_path = atc_loader_path
    dofile(atc_loader_path .. 'lua\\lotatc_server.lua')
  end
end
