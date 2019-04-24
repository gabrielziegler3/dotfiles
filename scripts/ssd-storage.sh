# Outputs the amount of storage remaining in SSD at /dev/sda2
free_space="$(df -h | grep home | grep -o "[0-9]\+G" | awk 'NR==3;')"
echo "${free_space}"
