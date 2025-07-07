local modules = {
    track = require('grim.track'),
}

Grim = {}

-- Grim is a table that serves as a namespace for the Grim library.   
-- It contains various modules that provide functionality for working with Reaper's API.
-- Each module is a table that contains functions and data related to a specific aspect of Reaper's API.
for name, module in pairs(modules) do
    if Grim[name] == nil then
        Grim[name] = module
    else
        error("Azrael already has a module named '" .. name .. "'")
    end
end

return Grim