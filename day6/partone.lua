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

for _, linha in ipairs(linhas) do
    local cols = split(linha)
    if _ == #linhas then
        for __, op in ipairs(cols) do
            ops[__] = op
        end
    else
        for __, num in ipairs(cols) do
            if colunas[__] then
                colunas[__][_] = num
            else
                colunas[__] = {}
                colunas[__][_] = num
            end
        end
    end
end

local totals = {}

for i, coluna in ipairs(colunas) do
    local op = ops[i]
    totals[i] = 0
    print("Tamanho coluna", #coluna)
    for _, val in ipairs(coluna) do
        print("Valor ", val, "Operação", op)
        if op == "+" then
            totals[i] = totals[i] + val
        else
            if totals[i] == 0 then
                totals[i] = val
            else
                totals[i] = totals[i] * val
            end
        end
    end
end

for i = 1, #colunas[1] do
    local str = ""
    for k = 1, #colunas do
        str = str .. " " .. colunas[k][i]
    end
    print(str)
end

local str = ""
for i, v in ipairs(ops) do
    str = str .. " " .. v
end
print(str)

local total = 0
for i, val in ipairs(totals) do
    print("TOTAL: ", val, "TOTAL ACUMULADO", total)
    total = total + val
end

print(total)
