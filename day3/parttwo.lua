local file = io.open('input', "r");
local input = file:read("l")

local pass = 0

local function searchHighJolt(start,trim,joltages)
    local max = 0
    local id = 0
    for i=start,#joltages-trim do
        local jolt = joltages[i]
        if tonumber(jolt) > max then
            id = i
            max = tonumber(jolt)
        end
    end
    return id, max
end


while input ~= nil do
    local joltages = {}
    print(input)
    for i=1,#input do
        joltages[#joltages+1] = string.sub(input,i,i)
    end

    local found = {}
    local start = 1
    local max = 12
    for i=1,max do
        local trim = max-i
        start, found[#found+1] = searchHighJolt(start,trim,joltages)
        joltages[start] = -1 
    end

    local total = table.concat(found)
    print("MAXIMUM:",total)
    local totalNum = tonumber(total)
    pass = pass + totalNum

    input = file:read("l")
end
file:close()
print(pass)