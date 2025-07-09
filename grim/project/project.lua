local track = require("grim.track.track")

---Project provides a wrapper for the reaper ReaProject type.
---@class Project
---@field _ ReaProject -- The ReaProject that this class wraps. As it is intended to be ignored/not intended to be modified directly, it is simply called _.
local Project = {}

---Project.New returns a newly initialized Project object.
---@param reaProject ReaProject
---@return Project | nil, string | nil
function Project:New(reaProject)
	if not reaper.ValidatePtr(reaProject, "ReaProject*") then
		return nil, "Project:New() requires a valid ReaProject."
	end

	local new = {}

	setmetatable(new, self)
	self.__index = self

	---@type ReaProject
	self._ = reaProject

	return new, nil
end

---Project.GetTrackByName retrieves a Track by its name in the current project.
---Retuns a table of Tracks, even if only one match is found.
---If no track with the given name is found, it returns nil.
---@param name string
---@return {}Track | nil
function Project:GetTracksByName(name)
	local tracks = {}
	local numTracks = reaper.CountTracks(self._)
	for i = 0, numTracks - 1 do
		local mediaTrack = reaper.GetTrack(self._, i)
		-- Returns "MASTER" for master track, "Track N" if track has no name.
		local _, mediaTrackName = reaper.GetTrackName(mediaTrack)
		if mediaTrackName == name then
			local newTrack, err = track.Track:New(self._, mediaTrack)
			if newTrack == nil or newTrack == err then
				-- TODO: Wrap this in pcall()
				error("Project:GetTracksByName() failed to create Track: " .. (err or "unknown error"))
			else
				table.insert(tracks, newTrack)
			end
		end
	end
	if #tracks >= 1 then
		return tracks
	end
	return nil
end

-- TODO: in progress
---track.GetTrackByName retrieves a Track by its name in the current project.
---If multiple tracks have the same name, it returns the Track with the lowest track number/index.
---If no track with the given name is found, it returns nil.
---@param name string
---@return Track | nil
function Project:GetTrackByName(name)
	-- TODO: call GetTracksByName and then return Track with lowest index.
end

return {
	Project = Project,
}
