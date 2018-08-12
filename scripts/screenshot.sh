#! /bin/bash
base_folder=/tmp/

# No arguments: full screenshot exported to ~/Pictures
if [[ $# -eq 0 ]]; then
	base_folder=~/Pictures/
	file=${base_folder}$(date '+%Y-%m-%d_%H-%M-%S')-screenshot.png
	import -window root $file
# If "full" is passed, full screenshot will be copied to clipboard
elif [[ "$1" == "full" ]]; then
	file=${base_folder}$(date '+%Y-%m-%d_%H-%M-%S')-screenshot.png
	import -window root $file
	xclip -selection clipboard $file -target image/png -i < ${file}
# If "selection", screenshot selection will be copied to clipboard
elif [[ "$1" == "selection" ]]; then
	file=${base_folder}$(date '+%Y-%m-%d_%H-%M-%S')-screenshot.png
	import $file
	xclip -selection clipboard $file -target image/png -i < ${file}
else
	echo "Wrong flag! try 'full' or 'selection'"
fi

