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

return {
    getTrackNumber = getTrackNumber,
    getTrackIndex = getTrackIndex,
    getTrackName = getTrackName,
    getParentTrack = getParentTrack,
    getFolderDepth = getFolderDepth,
}