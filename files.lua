Files = {}

-- TODO: add return value
Files.write_to_file = function(file, text) --> NoReturn
    local file = io.open(file, "w" )
    if file ~= nil then
        if text ~= nil then
            file:write(text)
        end
        file:close()
    end
end

return Files
