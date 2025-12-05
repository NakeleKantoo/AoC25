function split(inputstr, sep)
    -- if sep is null, set it as space
    if sep == nil then
        sep = '%s'
    end
    -- define an array
    local t = {}
    -- split string based on sep
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        -- insert the substring in table
        table.insert(t, str)
    end
    -- return the array
    return t
end

local file = io.open('input', "r")
local input = file:read("l")
-- local lines = split(input,"\n")

local ranges = {}

local totalFresh = 0

local i = 1
-- local currLine = lines[i]

while #input > 0 do
    local rangeStr = split(input, "-")
    --print(input)
    local range = {tonumber(rangeStr[1]),tonumber(rangeStr[2])}
    ranges[#ranges+1] = range
    i = i + 1
    input = file:read("l")
end

i = i + 1
input = file:read("l")

while input do
    for _,range in ipairs(ranges) do
        local test = tonumber(input)
        if range[1]<=test and test<=range[2] then
            totalFresh = totalFresh + 1
            break
        end
    end
    i = i + 1
    input = file:read("l")
end

file:close()
print("Total fresh: " .. totalFresh)
