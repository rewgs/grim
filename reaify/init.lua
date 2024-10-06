-- The entrypoint for the reaify library. 

local lfs = require("lfs")

local function isSymLink(filename) --> 
    local a = lfs.attributes(filename)
    local s = lfs.symlinkattributes(filename)
    return a and s and ( a.dev ~= s.dev or a.ino ~= s.ino )
  end

local function fileExists(file) --> bool
    local f = io.open(file, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function thisFile()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
 end

-- Loads the Ultraschall API into the Reaify namespace.
local function loadUltraschall(ultraschall_path)
    -- TODO:
    -- Installs Ultraschall via `git clone`:
    -- https://github.com/Ultraschall/ultraschall-lua-api-for-reaper
    -- local function installUltraschall()
    -- end

    if fileExists(ultraschall_path) then
        dofile(ultraschall_path)
    end

    if not ultraschall or not ultraschall.GetApiVersion then
        reaper.MB("Please install Ultraschall API, available via Reapack. Check online doc of the script for more infos.\nhttps://github.com/Ultraschall/ultraschall-lua-api-for-reaper", "Error", 0)
        return
    end
end


local function loadReaify(reaify_path)
    -- Returns all subdirectories and files within a given path.
    -- Might take some time with many folders/files.
    -- Optionally, you can filter for specific keywords(follows Lua's pattern-matching)
    -- Returns -1 in case of an error.
    -- Lua: integer found_dirs, array dirs_array, integer found_files, array files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(string path, optional string dir_filter, optional string dir_case_sensitive, optional string file_filter, optional string file_case_sensitive)
    local num_found_dirs, dirs_array, num_found_files, files_array = ultraschall.GetAllRecursiveFilesAndSubdirectories(reaify)

    -- Imports all files found in the reaify directory.
    -- Never imports the name of the file that's calling it -- this allows modules to use the same
    -- `dofile()` line as scripts: dofile(reaper.GetResourcePath() .. "/Scripts/rewgs-reaper-scripts/modules/init.lua")
    -- TODO: filter only .lua files
    for _, file in ipairs(files_array) do
        if file ~= reaify then
            -- reaper.ShowConsoleMsg(file .. "\n")
            dofile(file)
        end
    end
end


local function main()
    local thisFileName = debug.getinfo(1, 'S').source:match("[^/]*.lua$")

    local path = {}
    path.reaperResources = reaper.GetResourcePath()
    path.userPlugins = path.reaperResources .. "/UserPlugins/"

    -- The actual location of this path.
    path.thisFile = debug.getinfo(2, "S").source:sub(2):match("(.*/)")
    reaper.ShowConsoleMsg(path.thisFile)

    -- This is what the path *should* be, not necessarily what it *is.*
    path.reaify = {
        root = path.userPlugins .. "reaify/" .. "reaify/",
        initFile = path.reaify.root .. thisFileName,
    }

    path.ultraschall = path.userPlugins .. "ultraschall_api.lua"

    -- local title
    -- local msg
    -- if not fileExists(path.thisFile) then
    --     title = "Error loading Reaify!"
    --     msg = "Reaify is not properly installed! It should be located at: " .. path.reaify
    -- else
    --     title = "Successfully loaded Reaify!"
    --     msg = "Reaify was successfully found at: " .. path.reaify
    -- end
    -- _ = reaper.ShowMessageBox(msg, title, 0)

    -- loadUltraschall(path.ultraschall)
    -- loadReaify(path.reaify)
end
main()




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
