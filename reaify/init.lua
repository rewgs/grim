-- The entrypoint for the reaify library.
-- 

-- Loads the Ultraschall API into the Reaify namespace.
-- Installs Ultraschall if not installed already.
local function loadUltraschall(reaperResourcePath)
    -- Installs Ultraschall via `git clone`:
    -- https://github.com/Ultraschall/ultraschall-lua-api-for-reaper
    local function installUltraschall()
    end

    local function fileExists(name) --> bool
        local f = io.open(name, "r")
        if f ~= nil then
            io.close(f)
            return true
        else
            return false
        end
    end

    local ultraschall_path = reaperResourcePath .. "/UserPlugins/ultraschall_api.lua"
    if fileExists(ultraschall_path) then
        dofile(ultraschall_path)
    end
end


local function loadReaify(reaperResourcePath)
    loadUltraschall(reaperResourcePath)

    -- TODO: redo paths

    local rewgs_scripts = rewgs_reaper_scripts_root .. "/scripts"
    local rewgs_modules = rewgs_reaper_scripts_root .. "/modules"

    -- reaper.ShowConsoleMsg(rewgs_reaper_scripts_root .. "\n")
    -- reaper.ShowConsoleMsg(rewgs_scripts .. "\n")
    -- reaper.ShowConsoleMsg(rewgs_modules .. "\n")

    -- NOTE: moved out of this function
    -- local info = debug.getinfo(1, 'S')
    -- local this_file_name = info.source:match("[^/]*.lua$")
    -- local this_file_path = rewgs_modules .. "/" .. this_file_name

    -- reaper.ShowConsoleMsg(info.source)
    -- reaper.ShowConsoleMsg(this_file_path)

    -- Returns all subdirectories and files within a given path.
    -- Might take some time with many folders/files.
    -- Optionally, you can filter for specific keywords(follows Lua's pattern-matching)
    -- Returns -1 in case of an error.
    -- Lua: integer found_dirs, array dirs_array, integer found_files, array files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(string path, optional string dir_filter, optional string dir_case_sensitive, optional string file_filter, optional string file_case_sensitive)
    local num_found_dirs, dirs_array, num_found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(rewgs_modules)

    -- Imports all files found in the modules directory.
    -- Never imports the name of the file that's calling it -- this allows modules to use the same
    -- `dofile()` line as scripts: dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")
    -- TODO: filter only .lua files
    for _, file in ipairs(files_array) do
        if file ~= this_file_path then
            -- reaper.ShowConsoleMsg(file .. "\n")
            dofile(file)
        end
    end
end


local function main()
    -- local info = debug.getinfo(1, 'S')
    -- local thisFileName = info.source:match("[^/]*.lua$")
    local thisFileName = debug.getinfo(1, 'S').source:match("[^/]*.lua$")

    -- TODO: redo so that rewgs_modules isn't required
    -- local thisFilePath = rewgs_modules .. "/" .. this_file_name

    local reaperResourcePath = reaper.GetResourcePath()

    loadReaify(reaperResourcePath)
end




-- NOTE: Using this library as reference/inspiration:
-- https://gitlab.com/adamnejm/lazy-lua/-/blob/master/init.lua?ref_type=heads
-- return {
-- 	_VERSION        = "Reaify v0.0.1a",
-- 	_DESCRIPTION    = "Rewgs' Extension for the Reaper and Ultraschall Lua APIs",
-- 	_URL            = "https://github.com/rewgs/reaify",
--     -- TODO:
-- 	_LICENSE        = [[
-- 	]],

	-- os     = require_relative("os"),     ---@module "lazy.os"
	-- math   = require_relative("math"),   ---@module "lazy.math"
	-- table  = require_relative("table"),  ---@module "lazy.table"
	-- string = require_relative("string"), ---@module "lazy.string"
-- }
