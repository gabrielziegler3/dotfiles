# Outputs the amount of storage remaining in SSD at /dev/sda2
free_space="$(lsblk /dev/sda4 | grep -oE "[0-9]*\.?[0-9]*G")"
echo "${free_space}"
