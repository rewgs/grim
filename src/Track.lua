-- NOTE: This will replace Tracks.lua
-- Tracks will become a table of all tracks in the project, and will be a property defined in Project.lua

dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/Track-Marks.lua")

-- This effectively defines the "class" Track.
Track = {
    depth = reaper.GetMediaTrackInfo_Value(self.media_track, "I_FOLDERDEPTH")
}

-- Class properties and methods
function Track:index(i)
    if i == nil then
        self.index = "n/a"
    else
        self.index = i
    end
end

-- local _media_track = reaper.GetTrack(0, i)
function Track:media_track(reaper_project, i)
    self.media_track = reaper.GetTrack(reaper_project, i)
end

-- local depth = reaper.GetMediaTrackInfo_Value(media_track, "I_FOLDERDEPTH")
function Track:depth()
    self.depth = reaper.GetMediaTrackInfo_Value(self.media_track, "I_FOLDERDEPTH")
end

-- local _, name = reaper.GetTrackName(media_track)
function Track:name()
    _, self.name = reaper.GetTrackName(self.media_track)
end

-- local parent = reaper.GetMediaTrackInfo_Value(media_track, "P_PARTRACK")
function Track:parent()
    self.parent = reaper.GetMediaTrackInfo_Value(self.media_track, "P_PARTRACK")
end

function Track:parent_name(reaper_project)
    for i = 0, reaper.CountTracks(reaper_project) - 1 do
        local media_track = reaper.GetTrack(reaper_project)
        if media_track == self.parent then
            local _, media_track_name = reaper.GetTrackName(media_track)
            if media_track_name ~= nil then
                self.parent_name = media_track_name
            else
                self.parent_name = "n/a" -- This is to avoid a nil error in Reaper
            end
        end
    end
end

-- local num_media_items = reaper.CountTrackMediaItems(media_track)
function Track:num_media_items()
    self.num_media_items = reaper.CountTrackMediaItems(self.media_track)
end

function Track:media_items(reaper_project)
    local track_media_items = {}
    for i = 0, self.num_media_items - 1 do
        local media_item = reaper.GetMediaItem(reaper_project, i)
        local mute_state = reaper.GetMediaItemInfo_Value(media_item, "B_MUTE_ACTUAL")
        table.insert(track_media_items, {media_item, mute_state})
    end
    self.media_items = track_media_items
end

-- local is_selected = reaper.IsTrackSelected(media_track)
function Track:selection_state()
    self.selection_state = reaper.IsTrackSelected(self.media_track)
end

-- local track_mute_state = reaper.GetMediaTrackInfo_Value(media_track, "B_MUTE")
function Track.mute_state()
    reaper.GetMediaTrackInfo_Value(self.media_track, "B_MUTE")
end

function Track:is_marked(track_marks)
    local marks = {}
    for _, mark in ipairs(track_marks) do
        local mark_start, mark_end = string.find(self.name, mark)
        if mark_start ~= nil and mark_end ~= nil then
            table.insert(marks, mark)
        end
    end
    if #marks > 0 then
        self.marks = marks
    else
        self.marks = "n/a" -- This is to avoid a nil error in Reaper
    end
end

-- TODO
-- function Track:children(reaper_project)
-- end
