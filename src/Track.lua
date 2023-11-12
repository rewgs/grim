dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/Naming.lua")

Track = {
}

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

-- local num_media_items = reaper.CountTrackMediaItems(media_track)
function Track:num_media_items()
    self.num_media_items = reaper.CountTrackMediaItems(self.media_track)
end

-- local is_selected = reaper.IsTrackSelected(media_track)
function Track:selection_state()
    self.selection_state = reaper.IsTrackSelected(self.media_track)
end

-- local track_mute_state = reaper.GetMediaTrackInfo_Value(media_track, "B_MUTE")
function Track.mute_state()
    reaper.GetMediaTrackInfo_Value(self.media_track, "B_MUTE")
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

function Track:is_marked(track_marks)
    local marks = {}
    for _, mark in ipairs(track_marks) do
        local start_index, end_index = string.find(self.name, mark)
        if start_index ~= nil and end_index ~= nil then
            table.insert(marks, mark)
        end
    end
    if #marks > 0 then
        self.marks = marks
    end
end

-- TODO
-- function Track:children(reaper_project)
-- end
