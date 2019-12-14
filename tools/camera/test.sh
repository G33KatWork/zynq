#!/bin/bash

v4l2-ctl -d /dev/video0 --set-fmt-video=width=1504,height=480,pixelformat=GREY --stream-mmap --stream-count=32 --stream-to=test.raw
