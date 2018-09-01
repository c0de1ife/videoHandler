# Video Handler
a Lua implementation for x264 video handler on linux.

## dependency
need ffmpeg with x264 on linux.
test on centos7 and you can get a compiled ffmpeg in [ffmpeg_x264.7z](https://github.com/c0de1ife/videoHandler/blob/master/ffmpeg_x264.7z).

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
