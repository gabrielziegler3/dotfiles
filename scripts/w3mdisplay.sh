#!/bin/bash - 
#===============================================================================
#
#          FILE: w3mdisplay.sh
# 
#         USAGE: ./w3mdisplay.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 13/09/2018 16:27
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
#!/bin/bash
{ 
  while read line; do 
    firstchar=${line:0:1}
    if [[ $firstchar = '0' ]]; then
      # Showing a picture - pause for a moment, in case the terminal has a pending redraw.
      sleep 0.1
    fi
    echo "$line"
  done; 
} | /usr/lib/w3m/w3mimgdisplay

