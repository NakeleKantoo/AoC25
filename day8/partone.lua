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

local function pretty_print(value, indent, seen)
    indent = indent or 0
    seen = seen or {}

    local pad = string.rep("  ", indent)

    if type(value) ~= "table" then
        if type(value) == "string" then
            return string.format("%q", value)
        else
            return tostring(value)
        end
    end

    if seen[value] then
        return "<cycle>"
    end
    seen[value] = true

    local out = {}
    out[#out + 1] = "{\n"

    -- array part
    for i = 1, #value do
        out[#out + 1] = pad .. "  [" .. i .. "] = "
        out[#out + 1] = pretty_print(value[i], indent + 1, seen)
        out[#out + 1] = ",\n"
    end

    -- hash part
    for k, v in pairs(value) do
        if not (type(k) == "number" and k >= 1 and k <= #value and k % 1 == 0) then
            out[#out + 1] = pad .. "  ["

            if type(k) == "string" then
                out[#out + 1] = string.format("%q", k)
            else
                out[#out + 1] = tostring(k)
            end

            out[#out + 1] = "] = "
            out[#out + 1] = pretty_print(v, indent + 1, seen)
            out[#out + 1] = ",\n"
        end
    end

    out[#out + 1] = pad .. "}"
    return table.concat(out)
end



local file = io.open('example', "r")
local input = file:read("a")

local rawJBs = split(input, '\n')

local junctionBoxes = {}
local disconnectedJBs = {}
local connections = {}

for i, junctionBox in ipairs(rawJBs) do
    junctionBoxes[i] = split(junctionBox, ',')
    disconnectedJBs[i] = split(junctionBox, ',')
end

function getDistance(a, b)
    local dx = a[1] - b[1]
    local dy = a[2] - b[2]
    local dz = a[3] - b[3]
    return dx * dx + dy * dy + dz * dz
end

function areEqual(a, b)
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

function getClosest(jb, list)
    local closest = math.maxinteger
    local closestJB = {}
    local closestIndex = 0
    for i, test in ipairs(list) do
        if not areEqual(jb, test) then --assure im not grabbing the literal same point bruv...
            local distance = getDistance(jb, test)
            if distance < closest then
                closest = distance
                closestJB = test
                closestIndex = i
            end
        end
    end
    return closest, closestJB, closestIndex
end

function getNthClosestConnection(list, n)
    local distances = {}
    for _, jb in ipairs(list) do
        distances[#distances + 1] = table.pack(getClosest(jb, list))
        distances[#distances][#distances[#distances] + 1] = jb
    end
    --print("total distances: "..#distances)


    table.sort(distances, function(a, b)
        return a[1] < b[1]
    end)
    --print(pretty_print(distances))

    local ret = {}

    local count = 0
    local curr = 0
    for i, d in ipairs(distances) do
        if d[1] > curr then
            count = count + 1
            curr = d[1]
        end
        if count == n then
            ret = distances[i]
            break
        end
    end


    return ret
end

function existsInsideCircuit(jb, circuit)
    for k, ajb in ipairs(circuit) do
        if areEqual(jb, ajb) then
            --print("DEBUG ADD TO CT",index, i)
            return true
        end
    end
    return false
end

local ct = 0
function addToCircuit(found, unconnected)
    --need to check if the found one is already in a circuit
    local index = #connections + 1
    ct = ct + 1
    for i, circuit in ipairs(connections) do
        if existsInsideCircuit(found, circuit) or existsInsideCircuit(unconnected, circuit) then
            index = i
            break
        end
    end


    if connections[index] then
        --check if unconnected exists inside
        if not existsInsideCircuit(unconnected, connections[index]) then
            connections[index][#connections[index] + 1] = unconnected
        elseif not existsInsideCircuit(found, connections[index]) then
            connections[index][#connections[index] + 1] = found
        end
    else
        connections[index] = {}
        connections[index][#connections[index] + 1] = found
        connections[index][#connections[index] + 1] = unconnected
    end
end

--para cada jb desconectada, ache um proximo, e conecte-a
--local cc = 0
for i = 1, 10, 1 do
    local connection = getNthClosestConnection(junctionBoxes, i)
    --print(pretty_print(connection))
    addToCircuit(connection[2], connection[4])

    --print(i, index)
end

--print("Number of connections: " .. cc)
print("Number of circuits: " .. #connections)

for i, circuit in ipairs(connections) do
    print("Circuit n" .. i .. " contains: " .. #circuit .. " junction boxes")
end

table.sort(connections, function(a, b)
    return #a > #b
end)

local result = #connections[1] * #connections[2] * #connections[3]
print("Answer: " .. result)
