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

local file = io.open('example', 'r')
local input = file:read('a')

local lines = split(input, '\n')

local map = {}

local w, h = #lines[1], #lines

local beams = {} -- guardar a pos dos raios

local splitCount = 0 -- guardar quantas vezes se partiu

for i = 1, h do
    map[i] = {} -- gerar as linhas pra serem preenchidas
end

for y, line in ipairs(lines) do
    for x = 1, #line do
        local char = line:sub(x, x)
        map[y][x] = char
        if char == "S" then
            beams[1] = {
                x = x,
                y = y
            }
        end -- primeiro beam
    end
end

function percorrerBeams()
    -- percorrer beams
    for _, beam in pairs(beams) do
        if map[beam.y][beam.x] == "." then
            map[beam.y][beam.x] = "|"
        end

        if map[beam.y + 1] then
            -- checar se abaixo tem split ^
            if map[beam.y + 1][beam.x] == "^" then
                -- agora tem que fazer o split
                --splitCount = splitCount + 1 -- conta o split --nao conta

                --print("Split found for x"..beam.x.." y"..beam.y)

                -- tem que ver se tem um beam la já
                -- checar esquerda x-1
                local foundEsquerda = false
                for __, checkBeam in pairs(beams) do
                    if checkBeam.x == beam.x - 1 and checkBeam.y == beam.y + 1 then
                        foundEsquerda = true;
                        break
                    end
                end
                local foundDireita = false
                for __, checkBeam in pairs(beams) do
                    if checkBeam.x == beam.x + 1 and checkBeam.y == beam.y + 1 then
                        foundDireita = true;
                        break
                    end
                end

                if not foundEsquerda then
                    beams[#beams + 1] = {
                        x = beam.x - 1,
                        y = beam.y + 1
                    }
                end

                if not foundDireita then
                    beams[#beams + 1] = {
                        x = beam.x + 1,
                        y = beam.y + 1
                    }
                end

                beams[_] = nil
            else
                -- n dividiu, pode ir reto
                --mas checa se tem algum na reta pq ai n da ne 

                beam.y = beam.y + 1
            end
        end
    end
end

for i = 1, h do
    --print("Antes da coluna "..i.." tinha "..splitCount.." divisões")
    percorrerBeams()
    --print("Depois da coluna "..i.." tinha "..splitCount.." divisões")
    
end

local mapStr = ""

for y = 1, h do
    local debugStr = ""
    for x = 1, w do
        debugStr = debugStr .. map[y][x]
    end
    print(debugStr)
    mapStr = mapStr..debugStr.."\n"
end


for y,line in ipairs(map) do
    for x=1,#line do
        
        local char = line[x]
        if char == "|" then
            --checa se o debaixo é ^
            if map[y+1] then
                if map[y+1][x] == "^" then
                    splitCount=splitCount+1
                end
            end
        end
    end
end

print("Split count: "..splitCount)

