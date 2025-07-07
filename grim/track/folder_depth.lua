---FolderDepth defines a common interface for folder depth objects.
---The ReaScript API defines several folder depth values: 
---I_FOLDERDEPTH : int * : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
---This class makes the folder depth values more readable by providing a description for each integer value.
---@class FolderDepth
---@field num integer
---@field desc string
FolderDepth = {}

---new() returns a new FolderDepth object.
---@param num integer
---@param desc string
---@return table
function FolderDepth:new(num, desc) --> FolderDepth
    local new = {}
    setmetatable(new, self)
    self.__index = self

    ---@type integer
    self.num = num

    ---@type string
    self.desc = desc

    return new
end