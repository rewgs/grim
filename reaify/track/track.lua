dofile(reaper.GetResourcePath() .. "UserPlugins/reaify/reaify/utils/iterators.lua")
dofile(reaper.GetResourcePath() .. "UserPlugins/reaify/reaify/item/item.lua")

-------------------------------------------------------------------------------
-- Folder Depth
-------------------------------------------------------------------------------
-- In Python terms, this is basically a dataclass; is also sort of Enum-ish.
-- It can be difficult to remember which integer specifies which type of folder
-- depth, so this table simply bundles them together.

FolderDepth = {}

---@param o table|nil
---@param num integer
---@param desc string
function FolderDepth:new(o, num, desc) --> folderDepth
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    ---@type integer
    self.num = num

    ---@type string
    self.desc = desc

    return o
end

-------------------------------------------------------------------------------
-- Private functions - Track
-------------------------------------------------------------------------------
-- These are effectively "static methods" in Python terms.
-- The way the Reaper API is structured, being able to get track information
-- about *any* reaper.MediaTrack, not just the `self._` MediaTrack object,
-- makes the public methods much cleaner.

-- Returns the 1-based track number (as represented in the Reaper GUI).
--
-- args:
-- mediaTrack: reaper.MediaTrack
local function getTrackNumber(mediaTrack) --> integer
    -- >= 1: track number (1-based)
    -- 0: not found
    -- -1: master track
    local trackNumber = reaper.GetMediaTrackInfo_Value(mediaTrack, "IP_TRACKNUMBER")
    return trackNumber
end

-- Returns the 0-based track index (as represented in the Reaper GUI).
-- Master track is excluded; it always returns -1.
--
-- args:
-- mediaTrack: reaper.MediaTrack
local function getTrackIndex(mediaTrack) --> integer
    local trackNumber = getTrackNumber(mediaTrack)
    if trackNumber < 1 then
        if trackNumber == -1 then
            return trackNumber
            -- TODO:
            -- else
            --     raise error -- track does not exist
        end
    else
        return trackNumber - 1
    end
end

-- args:
-- mediaTrack: reaper.MediaTrack
local function getTrackName(mediaTrack) --> string
    ---@type boolean, string
    local _, name = reaper.GetTrackName(mediaTrack)

    -- TODO:raise error
    -- if name == nil then
    -- end

    -- TODO:
    -- if name == "MASTER" then
    -- end

    -- TODO: This will actually be "Track 0" if the first track,
    -- "Track 1" if the second, etc. Need `N` to be an integer.
    -- if name == "Track N" then
    -- end

    return name
end

-- args:
-- mediaTrack: reaper.MediaTrack
local function getParentTrack(mediaTrack) --> reaper.MediaTrack
    local parent = reaper.GetParentTrack(mediaTrack)

    -- TODO: raise error?
    -- if parent == nil then
    -- end

    return parent
end

-- args:
-- mediaTrack: reaper.MediaTrack
local function getFolderDepth(mediaTrack) --> FolderDepth
    -- args:
    -- num: integer
    local function getFolderDepthDesc(num)
        if num == 0 then
            return "normal"
        elseif num == 1 then
            return "parent"
        else
            -- NOTE:
            -- At the moment, I'm ignoring nested values (-1, -2, etc), as
            -- I'm not sure of the best way forward. The better move would probably
            -- be a large and robust recursive function that maps the tree-
            -- like hierarchy of the track relationships.
            -- Will revisit in the future.
            return nil
        end
    end

    local num = reaper.GetMediaTrackInfo_Value(mediaTrack, "I_FOLDERDEPTH")
    local desc = getFolderDepthDesc(num)
    local folderDepth = FolderDepth.new(num, desc)
    return folderDepth
end


-------------------------------------------------------------------------------
-- Track
-------------------------------------------------------------------------------
-- Provides a wrapper for functions that take reaper.MediaTrack arguments.

Track = {}

-- TODO: Wrap function body in pcall() for error-handling, especially in the
-- case that o is not passed or does not exist.
--
-- Returns a wrapper for reaper.MediaTrack.
--
-- args:
-- o: table or nil
-- mediaTrack: reaper.MediaTrack
function Track:new(o, project, mediaTrack) --> Track
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.project = project
    self._ = mediaTrack

    return o
end

-- Returns the 1-based track number (as represented in the Reaper GUI).
function Track:getTrackNumber() --> integer
    return getTrackNumber(self._)
end

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

