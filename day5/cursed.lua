--this file is cursed
--it consumed 12gb of my ram before running out and core dumping
--i've never seen lua core dump before
--this is _bad_ code



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

local freshIDs = {}

local totalFresh = 0

local i = 1
-- local currLine = lines[i]

while #input > 0 do
    local range = split(input, "-")
    --print(input)
    for k = range[1], range[2] do
        freshIDs[k] = true
    end
    i = i + 1
    input = file:read("l")
end

i = i + 1
input = file:read("l")

while input do
    if freshIDs[tonumber(input)] then
        totalFresh = totalFresh + 1
    end
    i = i + 1
    input = file:read("l")
end

file:close()
print("Total fresh: " .. totalFresh)
