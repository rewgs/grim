# grim

`grim` is a library that significantly speeds up ReaScript development by providing a more object-oriented approach for interacting with the Reaper [ReaScript Lua API](https://www.reaper.fm/sdk/reascript/reascripthelp.html#l). Utilizes the [Ultraschall API](https://mespotin.uber.space/Ultraschall/US_Api_Introduction_and_Concepts.html) for some extra functionality.

All values have type annotations according to the [`lua-language-server` specification](https://github.com/LuaLS/lua-language-server/wiki/Annotations).

<!-- Powers the [`rea`](https://github.com/rewgs/rea) script library. -->

<!-- ## setup -->
<!-- Any ReaScript file that references this library needs to be able to import it from an absolute location that does not change from computer to computer. -->
<!-- 1. Install the [Ultraschall API](https://github.com/Ultraschall/ultraschall-lua-api-for-reaper?tab=readme-ov-file#reapack) via ReaPack. -->

## why?

While the ReaScript API is extensive and provides a _lot_ of functionality, it isn't built for expressiveness -- Reaper script developers often find themselves writing a lot of the same code over and over, and most tasks take more lines of code than seems necessary. 

For example, this is how one might go about getting a particular track by name:

```lua
local function getTrackByName(query)
    local matches = {}
    local numTracks = reaper.CountTracks(0)
    for i = 0, numTracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, name = reaper.GetTrackName(track)
        if name == query then
            table.insert(matches, track)
        end
    end
end

local track = getTrackByName("some track")
```

And this is how one achieves the same thing with `grim`:

```lua
grim = require('grim')
project = Project.New()
track = project.GetTrackByName("some track") -- This returns the first match
-- Also available is `project.GetTracksByName()` (notice that "Tracks" is plural), which returns a table of all tracks named the query. 
```

## use

It is highly recommended that you use VS Code along with [Antoine Balaine](https://www.linkedin.com/in/antoinebalaine/)'s excellent [`REAPER ReaScript`](https://marketplace.visualstudio.com/items?itemName=AntoineBalaine.reascript-docs) extension, as `grim`'s type annotations for Reaper's types are in accordance with this extension.