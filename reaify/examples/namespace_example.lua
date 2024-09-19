-- Some good info:
-- - https://stackoverflow.com/questions/4394303/how-to-make-namespace-in-lua
-- - https://www.lua.org/pil/15.2.html

Some_Namespace = {}

Some_Namespace.some_function = function()
    reaper.ShowConsoleMsg("Running some_function() from namespace Some_Namespace!")
end

return Some_Namespace
