# Video Handler
a Lua implementation for x264 video handler on linux.

## dependency
need ffmpeg with x264 on linux.
test on centos7.

## feature
>* get info from video.
>* get some captures.
>* transform video to some resolutions.

## usage
in your lua files:
```lua
-- import
local videoHandler = require("videoHandler")
-- instantiate
local video = videoHandler:new()
-- set path.
video:setPath("001.pm4")
-- get info(duration, width, height).
print(video:getInfo())
-- get captures.
video:capture()
-- transform.
video:fitHeight()
```
