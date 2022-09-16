local x = 0
local y = 0

local function unsignedToSigned(val)
    local bandval = bit32.lshift(0x80, 8) --0/8 for int8/16
    val = val - bit32.band(val, bandval) * 2
    return val
end

local function getAngles()
    local command, data = crossfireTelemetryPop()
    
    if command == 0x2F then
        if data[2] == 238 then
            x = unsignedToSigned(data[3]*256 + data[4]) -- -900 - 900 -> -90° - 90°
            y = unsignedToSigned(data[5]*256 + data[6]) -- -900 - 900 -> -90° - 90°
        end
    end
end

local outputs = {"HdX", "HdY"}

local function run()
    getAngles()
    return x, y
end

return { output=outputs, run=run }