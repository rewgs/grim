---@description grim
---@author Alex Ruger aka rewgs
---@version 0.0.1-alpha
---@about This library significantly speeds up ReaScript development by providing a more object-oriented approach for interacting with Reaper's ReaScript Lua API. 

local item = require("grim.item.item")
local project = require("grim.project.project")
local track = require("grim.track.track")

return {
	item = item,
	project = project,
	track = track,
}
