# Outputs the amount of storage remaining in SSD at /dev/sda2
values="$(df -h | grep /dev/sda2 | cut -d " " -f13)"
echo "${values}"
