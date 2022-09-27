local yaw = 0
local pitch = 0

local function unsignedToSigned(val)
    local bandval = bit32.lshift(0x80, 8) --0/8 for int8/16
    val = val - bit32.band(val, bandval) * 2
    return val
end

local function getAngles()
    local command, data = crossfireTelemetryPop()
    
    if command == 0x2F then
        if data[2] == 238 then
            yaw = unsignedToSigned(data[3]*256 + data[4])*2.276 -- -450 - 450 = -45° - 45° -> -1024 - 1024
            pitch = unsignedToSigned(data[5]*256 + data[6])*2.276 -- -450 - 450 = -45° - 45° -> -1024 - 1024
        end
    end
end

local outputs = {"HYaw", "HPit"}

local function run()
    getAngles()
    return yaw, pitch
end

return { output=outputs, run=run }