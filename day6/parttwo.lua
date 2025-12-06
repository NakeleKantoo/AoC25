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

local colunas = {}
local ops = {}

local linhas = split(input, "\n")

--Vou ter que descobrir o tamanho de cada coluna baseado na distancia entre as operações

local lens = {}
local linhaOperacoes = linhas[#linhas] -- a ultima

for i=1,#linhaOperacoes do --percorrer toda a linha de operações
    local segmento = linhaOperacoes:sub(i,i)
    if segmento == "+" then
        ops[#ops+1] = "+"
        lens[#ops] = 0
    elseif segmento == "*" then
        ops[#ops+1] = "*"
        lens[#ops] = 0
    elseif segmento == " " then
        lens[#lens] = lens[#lens] + 1
    end
end

lens[#lens] = lens[#lens] + 1 --tem que contar o ultimo q n contou

--agora é pegar todas as linhas
function getNumCol(col)
    local n = ""
    for i=1,#linhas-1 do
        local linha = linhas[i]
        n = n..linha:sub(col,col)
        --print("CHAR "..linha:sub(col,col).." FROM LINE "..i.." AT "..col)
    end
    return tonumber(n)
end

local aggregate = 0
for i,length in ipairs(lens) do
    aggregate = aggregate+length
    colunas[i] = {}
    for k=aggregate,aggregate-length+1,-1 do
        colunas[i][#colunas[i]+1] = getNumCol(k)
        print("numero da coluna "..i.." é "..getNumCol(k))
    end
    aggregate=aggregate+1
end 


local totals = {}

for _,coluna in ipairs(colunas) do
    local op = ops[_]
    totals[_] = 0
    for i,num in ipairs(coluna) do
        if op == "+" then
            totals[_] = totals[_] + num
        elseif op == "*" then
            if totals[_] == 0 then
                totals[_] = num
            else
                totals[_] = totals[_] * num
            end            
        end
    end
end







local total = 0
for i, val in ipairs(totals) do
    print("TOTAL: ", val, "TOTAL ACUMULADO", total)
    total = total + val
end

print(total)
