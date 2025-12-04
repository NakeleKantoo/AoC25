local file = io.open('ids')
local input = file:read("a")
local pass = 0
-- define a function to spring a string with give separator
function split(inputstr, sep)
    -- if sep is null, set it as space
    if sep == nil then
        sep = '%s'
    end
    -- define an array
    local t = {}
    -- split string based on sep
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)')
    do
        -- insert the substring in table
        table.insert(t, str)
    end
    -- return the array
    return t
end

local ranges = split(input, ',')

for i, v in ipairs(ranges) do
    --print("RANGE: "..v)
    local r = split(v,"-")
    local start = r[1]
    local finish = r[2]
    start = tonumber(start)
    finish = tonumber(finish)
    for curr=start,finish do
        local check = tostring(curr)
        if #check%2==0 then
            local comeco = string.sub(check,1,#check/2)
            local fim = string.sub(check,#check/2+1)
            --print(curr, comeco, fim)
            if comeco == fim then
                --print(curr)
                pass = pass + curr
            end
        end
    end

end
print(pass)


file:close()
