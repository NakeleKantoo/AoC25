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

local file = io.open('input', 'r')
local input = file:read('a')

local lines = split(input, '\n')

local map = {}

local w, h = #lines[1], #lines
local alternateRealities = 0

for y=1,h do
    map[y] = {}
end

for y,line in ipairs(lines) do
    for x=1,#line do
        local char = line:sub(x,x)
        if char=="S" then
            map[y][x] = 1
        elseif char=="^" then
            map[y][x] = -1
        else
            map[y][x] = 0
        end
    end
end

for i=2,h do
    --para cada linha
    local line = map[i]
    local previous = map[i-1]
    for x=1,#previous do
        local val = previous[x]
        local present = line[x]
        if val>0 then
            if present == -1 then --^ split
                line[x-1] = line[x-1]+val
                line[x+1] = line[x+1]+val
                line[x] = 0
            else
                line[x] = line[x]+val
            end
        end
    end
end

local mapStr = ""

for y = 1, h do
    local debugStr = ""
    for x = 1, w do
        debugStr = debugStr .." ".. map[y][x]
    end
    print(debugStr)
    mapStr = mapStr..debugStr.."\n"
end

local last = map[#map]
for i=1,w do
    alternateRealities = alternateRealities + last[i]
end
print("Split count: " .. alternateRealities)

