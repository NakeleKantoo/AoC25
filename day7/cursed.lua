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

local beam = {} -- guardar a pos do raio

local alternateRealities = 0 -- guardar quantas vezes se partiu

for i = 1, h do
    map[i] = {} -- gerar as linhas pra serem preenchidas
end

for y, line in ipairs(lines) do
    for x = 1, #line do
        local char = line:sub(x, x)
        map[y][x] = char
        if char == "S" then
            beam = {
                x = x,
                y = y
            }
        end -- primeiro beam
    end
end

-- tenho q manter todas as decisões tomadas
local decisions = {}
-- a decisão de maior ordem vai ser a que eu vou usar pra recorrer
-- a primeira decisão vai ser o primeiro split
-- vou para a esquerda pela primeira vez, pra direita na segunda
while true do
    beam.y = beam.y + 1
    if map[beam.y][beam.x] == "^" then
        decisions[#decisions + 1] = {
            went = false,
            x = beam.x,
            y = beam.y
        }
        beam.x = beam.x - 1
        break
    end
end

-- okay agora é fazer enquanto tiver decisões pra retomar
while #decisions > 0 do
    -- e enquanto o beam não ir chegar no limite
    while beam.y < h do
        -- vou mandar o beam pra baixo
        beam.y = beam.y + 1
        -- se tiver uma ^ marque como decisão
        if map[beam.y][beam.x] == "^" then
            decisions[#decisions + 1] = {
                went = false,
                x = beam.x,
                y = beam.y
            }
            beam.x = math.max(1,beam.x - 1)
        end
    end

    --chegou no fim, marque como uma das realidades
    alternateRealities = alternateRealities + 1
    local decision = nil
    while decision == nil do    
        --agora volte pra decisão mais recente
        decision = decisions[#decisions]
    
        --se a decisão ja foi percorrida, elimine-a
        if decision then
            if decision.went then 
                table.remove(decisions,#decisions)
                decision = nil
            end
        else
            break --n tem mais decisões, large mão
        end
    end

    if decision then
        --marque a decisão como percorrida pra esquerda
        decision.went = true
        --volte o beam pra ela
        beam.x = decision.x+1 --para direita
        beam.y = decision.y
        --loop
    end
end

local mapStr = ""

for y = 1, h do
    local debugStr = ""
    for x = 1, w do
        debugStr = debugStr .. map[y][x]
    end
    print(debugStr)
    mapStr = mapStr .. debugStr .. "\n"
end

print("Split count: " .. alternateRealities)

