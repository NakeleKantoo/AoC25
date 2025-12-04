local file = io.open('input', "r");
local input = file:read("l")
local dial = 50
local pass = 0

while input ~= nil do
    local dir = string.sub(input, 1, 1)
    local num = string.sub(input, 2)
    num = tonumber(num)

    if dir and num then
        local sign = 1
        if dir == "R" then
            sign = 1
        else
            sign = -1
        end

        local count = num

        for i = 1, count do
            dial = dial + sign
            if dial > 99 then
                dial = 0
            
            elseif dial < 0 then
                dial = 99
            
            end

            if dial == 0 then
                pass = pass + 1
            end
        end

        input = file:read("l")
    else
        input = nil
    end
end
file:close()
print(pass)
