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
    -- print(input)
    local range = {tonumber(rangeStr[1]), tonumber(rangeStr[2])}
    ranges[#ranges + 1] = range
    i = i + 1
    input = file:read("l")
end

local currS, currF = nil,nil

table.sort(ranges, function(x,y) return x[1] < y[1] end)
local total = 0
local currS, currF = ranges[1][1], ranges[1][2]

for i = 2, #ranges do
    local s, f = ranges[i][1], ranges[i][2]
    -- if the next range starts at or before currF+1 -> merge
    if s <= currF + 1 then
        if f > currF then currF = f end -- extend
    else
        -- finalize current
        total = total + (currF - currS + 1)
        currS, currF = s, f
    end
end
total = total + (currF - currS + 1)

file:close()
print("Total fresh: " .. total)
