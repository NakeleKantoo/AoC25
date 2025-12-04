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
local input = file:read("a")
local lines = split(input, '\n')

local countRolls = 0

local grid = {}
local w, h = #lines[1], #lines

for i = 1, w do
    grid[i] = {}
end

for y, line in ipairs(lines) do
    for x = 1, #line do
        local char = line:sub(x, x)
        grid[y][x] = char
    end
end

local directions = {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}}

local debugVar = ""

local removed = {}

function removeRolls()
    for y, v in ipairs(grid) do
        for x, char in ipairs(v) do
            -- check all eight directions
            if char == "@" then
                local sum = 0
                for _, direction in ipairs(directions) do
                    -- check if y line exists
                    if grid[y + direction[2]] then
                        local column = grid[y + direction[2]]
                        -- check if y exists
                        if column[x + direction[1]] then
                            if column[x + direction[1]] == "@" then
                                sum = sum + 1
                            end
                        end
                    end
                end
                if sum < 4 then
                    countRolls = countRolls + 1
                    removed[#removed+1] = {y,x}
                    debugVar = debugVar.."X"
                else
                    debugVar = debugVar.."@"
                end
            else
                debugVar = debugVar.."."
            end
        end
        debugVar = debugVar.."\n"
    end
end

function deleteRolls()
    for i,v in ipairs(removed) do
        grid[v[1]][v[2]] = "."
    end
    removed = {}
end

removeRolls()

--while #removed>0 do
--    deleteRolls()
--    removeRolls()
--end

print(debugVar)

print("Count of rolls: ", countRolls)

file:close()
