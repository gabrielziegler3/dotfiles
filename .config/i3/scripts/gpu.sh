#!/bin/bash
temp=$(sensors amdgpu-pci-2700 2>/dev/null | awk '/edge/{gsub(/\+/,"",$2); print $2}')
power=$(sensors amdgpu-pci-2700 2>/dev/null | awk '/PPT/{printf "%.0fW", $2}')
echo "${temp:-??} ${power:-??}"
