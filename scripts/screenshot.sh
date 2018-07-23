#! /bin/bash

base_folder=/tmp/

file=${base_folder}$(date '+%Y-%m-%d_%H-%M-%S')-screenshot.png

import $file

xclip -selection clipboard $file -target image/png -i < ${file}
