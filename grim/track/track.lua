local folderDepth = require('grim.track.folderDepth')
local utils = require('grim.track.utils')

---Track provides a wrapper for the reaper MediaTrack type.
---It provides methods to interact with the track, such as getting its name,
---index, and parent track, as well as methods to select or deselect the track.
---It also provides methods to get the track's folder depth and media items.
---@class Track
---@field project ReaProject -- The ReaProject that this Track belongs to.
---@field _ MediaTrack -- The MediaTrack object that this Track wraps. As it is intended to be ignored/not intended to be modified directly, it is simply called _.
---@field exists boolean -- Whether the track exists in the project.
---@field isMaster boolean -- Whether the track is the master track.
Track = {}

---Track.new returns a newly initialized Track object.
---@param reaProject    ReaProject
---@param mediaTrack MediaTrack
---@return Track | nil, string | nil
function Track:New(reaProject, mediaTrack)
    if not reaProject or not mediaTrack then
        return nil, "Track:new() requires a ReaProject and a MediaTrack."
    end

    if not reaper.ValidatePtr(reaProject, "ReaProject*") then
        return nil, "Track:new() requires a valid ReaProject."
    end

    if not reaper.ValidatePtr(mediaTrack, "MediaTrack*") then
        return nil, "Track:new() requires a valid MediaTrack."
    end

    local new = {}

    setmetatable(new, self)
    self.__index = self

    ---@type ReaProject
    self.project = reaProject

    ---@type MediaTrack
    self._ = mediaTrack

    ---@type boolean
    self.exists = nil

    ---@type boolean
    self.isMaster = nil

    return new, nil
end

---Track.GetTrackNumber returns the 1-based track number (as represented in the Reaper GUI).
---@return integer
function Track:GetTrackNumber()
    local trackNumber = reaper.GetMediaTrackInfo_Value(self._, "IP_TRACKNUMBER")

    if trackNumber == 0 then
        self.exists = false
    else
        self.exists = true
        if trackNumber == -1 then
            self.isMaster = true
        else
            self.isMaster = false
        end
    end

    return trackNumber
end

---Track.GetTrackIndex returns the 0-based track index (as represented in the Reaper GUI).
---@return integer
function Track:GetTrackIndex()
    local trackNumber = self:GetTrackNumber()
    return trackNumber - 1
end


---Track.GetName returns the track's name. If the track has no name, it returns nil instead of an empty string.
---@return string | nil
function Track:GetName()
    local _, name = reaper.GetTrackName(self._)
    if name == "" then
        return nil
    else
        return name
    end
end

---Track.GetParentTrack retrieves the parent MediaTrack of the current track, and then returns a newly-initialized Track object for it.
---If the track has no parent, it returns nil.
---@return Track | nil
function Track:GetParentTrack()
    local parentTrack = reaper.GetParentTrack(self._)
    if not parentTrack then
        return nil
    end

    local parent, err = Track:New(self.project, parentTrack)
    if parent == nil or err ~= nil then
        -- TODO: encapsulate in pcall()
        error("Track:GetParentTrack() failed to create Track: " .. (err or "unknown error"))
    end
    parent.exists = true
    parent.isMaster = false
    return parent
end

---Track.GetFolderDepth retrieves the numerical folder depth of the track, and then returns a newly-initialized FolderDepth object for it, 
---which contains the number's corresponding descriptive string.
---@return FolderDepth
function Track:GetFolderDepth()
    local num = reaper.GetMediaTrackInfo_Value(self._, "I_FOLDERDEPTH")
    local f, err = folderDepth:New(num)
    if f == nil or err ~= nil then
        -- TODO: encapsulate in pcall()
        error("Track:GetFolderDepth() failed to create FolderDepth: " .. (err or "unknown error"))
    end
    return f
end

-- TODO: This is a placeholder for the actual implementation. Depends on item.Item, which does not yet exist.
--
---Track.GetItems returns a list of media items in the track.
---@return {}Item
function Track:GetItems()
end

---Track.IsSelected returns whether the Track is selected in the Reaper GUI.
---@return boolean
function Track:IsSelected()
    local isSelected = reaper.GetMediaTrackInfo_Value(self._, "I_SELECTED")
    if isSelected == 1 then
        return true
    end
    return false
end

---Track.Select selects the Track in the Reaper GUI.
---If the Track is already selected, it does nothing.
---If the Track does not exist, it does nothing.
---If the Track is the master track, it does nothing.
---If not successful, it returns an error message.
---@return string | nil
function Track:Select()
    if not self:IsSelected() then
        -- This return value is a boolean, but I'm not sure what it means. I'm guessing it indicates success.
        local success = reaper.SetMediaTrackInfo_Value(self._, "I_SELECTED", 1)
        if not success then
            return "Track:Select() failed to select track: " .. (self:GetName() or "unknown track")
        end
    end
    return nil
end

---Track.Deselect deselects the Track in the Reaper GUI.
---If the Track is already deselected, it does nothing.
---If the Track does not exist, it does nothing.
---If the Track is the master track, it does nothing.
---If not successful, it returns an error message.
---@return string | nil
function Track:Deselect()
    if self:IsSelected() then
        -- This return value is a boolean, but I'm not sure what it means. I'm guessing it indicates success.
        local success = reaper.SetMediaTrackInfo_Value(self._, "I_SELECTED", 0)
        if not success then
            return "Track:Deselect() failed to deselect track: " .. (self:GetName() or "unknown track")
        end
    end
    return nil
end

---Track.ToggleSelected toggles the selection state of the Track in the Reaper GUI.
---If the Track is selected, it deselects it.
---If the Track is not selected, it selects it.
---If the Track does not exist, it does nothing.
---If the Track is the master track, it does nothing.
---@return nil
function Track:ToggleSelected()
    if self:IsSelected() then
        self:Deselect()
    else
        self:Select()
    end
end

-- TODO: This is a placeholder for the actual implementation. Need to also check for child tracks.
-- TODO: Maybe make this a field of Track instead?
function Track:IsParent() --> boolean
    local parentTrack = reaper.GetParentTrack(self._)
    if not parentTrack then
        return true
    end
    return false
end

-- TODO: In progress
function Track:GetChildTracks() --> {}Track
    local childTracks = {}
    local numTracks = reaper.CountTracks(self.project)

    for i = 0, numTracks - 1 do
        local track = reaper.GetTrack(self.project, i)
        if track and reaper.GetParentTrack(track) == self._ then
            local child, err = Track:New(self.project, track)
            if child == nil or err ~= nil then
            end
        end
    end
end


return {
    Track = Track,
}