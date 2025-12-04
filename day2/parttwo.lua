local file = io.open('ids')
local input = file:read("l")
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
        local strs = {}
        for k=1,#check/2 do
            if #check%k==0 then --check if evenly divide
                -- 1 1 1
                -- 23 23 23
                -- 243 243 243 243
                local str = string.sub(check,1,k)
                strs[tostring(#str)] = str
                --print(curr, "string: ", strs[#strs])
            end
        end
        for a,complete in pairs(strs) do
            local s = ""
            for k=1,#check/tonumber(a) do
                s = s..complete
            end
            --print("CONFERINDO: ",check, s)
            if check == s then
                --print("Passou: ",curr)
                pass = pass + curr
                break
            end
        end
    end
end
print(pass)


file:close()
