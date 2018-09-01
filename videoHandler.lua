---
--- a Lua implementation for video handler on linux.
--- need ffmpeg with x264.
--- test on centos7.
---

local videoHandler = {}
videoHandler.errNoPath = "err: video path is not exist."
videoHandler.errNoFile = "err: file is not a video or file is not exist."

function videoHandler:setPath(path)
    if path ~= self.path then
        self:reset()
        self.path = path
    end
end

function videoHandler:checkPath()
    if not self.path then
        error(self.errNoPath)
    end
end

function videoHandler:getInfo(path)
    if path then
        self:setPath(path)
    end
    self:checkPath()
    if not self.duration then
        local function str2time(str)
            local h, m, s = string.match(str, "(.+):(.-):(.+)")
            return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
        end

        local filename = os.tmpname()
        local cmd = "ffmpeg -i " .. self.path .. " 2>" .. filename
        --print(cmd)
        if os.execute(cmd) then
            local file = io.open(filename)
            local data = file:read("a")
            file:close()
            --print(data)
            local duration = string.match(data, "Duration: (.-),")
            self.duration = str2time(duration)
            local width, height = string.match(data, ", (%d+)x(%d+)")
            self.width, self.height = tonumber(width), tonumber(height)
        end
        os.remove(filename)
        if not self.duration then
            error(self.errNoFile)
        end
    end
    return self.duration, self.width, self.height
end


-- get one image more than input as a cover.
function videoHandler:capture(number)
    local totalTime = self:getInfo()
    number = number or 3
    local startTime, rate = 1, (number - 1) / (totalTime - 2)
    if totalTime < 2 then
        startTime = 0
        rate = 0.1
    end
    local cmd = string.format("ffmpeg -ss %s -i %s -f image2 -r %s %s%%3d.jpg", startTime, self.path, rate, string.match(self.path, "(.+)%."))
    --print(cmd)
    os.execute(cmd)
end

function videoHandler:fitHeight(levels)
    local _, _, height = self:getInfo()
    levels = levels or { 240, 480, 720, 1080 }
    for _, v in pairs(levels) do
        if height >= v then
            local name, extra = string.match(self.path, "(.+)%.(.-)$")
            local cmd = string.format("ffmpeg -y -i %s -vcodec libx264 -preset fast -filter:v scale=-2:%s -crf 26 %s_%s.%s", self.path, v, name, v, extra)
            --print(cmd)
            os.execute(cmd)
        end
    end
end

function videoHandler:new()
    return setmetatable({}, { __index = self })
end

function videoHandler:reset()
    self.path = nil
    self.duration = nil
    self.width = nil
    self.height = nil
end

return videoHandler


