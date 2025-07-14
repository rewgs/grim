-- import grim library
local grim = nil
local grim_path = reaper.GetResourcePath() .. "/UserPlugins/grim/grim/grim.lua"
if reaper.file_exists(grim_path) then
    grim = dofile(grim_path)
else
    reaper.ShowMessageBox("Grim library not found at: " .. grim_path, "Error", 0)
    return
end

local project = grim.Project:New()