local folderDepth = require('grim.track.folder_depth')
local utils = require('grim.track.utils')

---Track provides a wrapper for reaper.MediaTrack.
-- It provides methods to interact with the track, such as getting its name,
-- index, and parent track, as well as methods to select or deselect the track.
-- It also provides methods to get the track's folder depth and media items.
---@class Track
---@field project ReaProject -- The ReaProject that this Track belongs to.
---@field _ MediaTrack -- The MediaTrack object that this Track wraps. As it is intended to be ignored/not intended to be modified directly, it is simply called _.
---@field exists boolean -- Whether the track exists in the project.
---@field isMaster boolean -- Whether the track is the master track.
Track = {}

-- TODO: Wrap function body in pcall() for error-handling, especially in the
-- case that o is not passed or does not exist.
--
---Track.new returns a newly initialized Track object.
---@param project    ReaProject
---@param mediaTrack MediaTrack
---@return Track
function Track:new(project, mediaTrack) --> Track
    local new = {}

    setmetatable(new, self)
    self.__index = self

    ---@type ReaProject
    self.project = project

    ---@type MediaTrack
    self._ = mediaTrack

    ---@type boolean
    self.exists = nil

    ---@type boolean
    self.isMaster = nil

    -- self.exists = reaper.ValidatePtr(self._, "MediaTrack")

    return new
end

---Track.getTrackNumber returns the 1-based track number (as represented in the Reaper GUI).
---@return integer
function Track:getTrackNumber() --> integer
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

-- TODO: Improve all methods below from here.

-- Returns the 0-based track index (as represented in the Reaper GUI).
-- Master track is excluded; it always returns -1.
function Track:getTrackIndex()
    return getTrackIndex(self._)
end

function Track:getName() --> string
    return getTrackName(self._)
end

function Track:getParentTrack() --> reaper.MediaTrack
    return getParentTrack(self._)
end

function Track:getFolderDepth() --> FolderDepth
    return getFolderDepth(self._)
end

-- Returns the track's media items as Items.
function Track:getItems() --> {}Item
    local items = {}
    local numMediaItems = reaper.CountTrackMediaItems(self._)
    for i in iterators.Range(numMediaItems) do
        local item = Item:new(self.project, self._)
        table.insert(items, item)
    end
end

function Track:isSelected() --> boolean
    return reaper.IsTrackSelected(self._)
end

function Track:select() --> nil
    if not self:isSelected() then
        reaper.SetMediaTrackInfo_Value(self._, "I_SELECTED", true)
    end
end

function Track:deselect() --> nil
    if self:isSelected() then
        reaper.SetMediaTrackInfo_Value(self._, "I_SELECTED", false)
    end
end

-- TODO:
function Track:getChildMediaTracks() --> {}reaper.MediaTrack
end

