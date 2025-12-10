#!/bin/bash

# Simple Linux Permission Visualizer
# Scans a folder and prints file permissions, owner, group
# Marks risky permissions like 777, suid, sgid, sticky bit

if [ -z "$1" ]; then
    echo "Usage: bash permission-visualizer.sh /path/to/folder"
    exit 1
fi

target="$1"

# Check if folder exists
if [ ! -d "$target" ]; then
    echo "Directory not found: $target"
    exit 1
fi

echo "Scanning: $target"
echo

# Recursively scan all files and folders
find "$target" -printf "%p\n" | while read file
do
    perms=$(stat -c "%A" "$file")   # rwxr-xr-x
    octal=$(stat -c "%a" "$file")   # 755
    owner=$(stat -c "%U" "$file")
    group=$(stat -c "%G" "$file")

    msg=""

    # Detect world writable (7 in others position)
    if [[ "${octal:2:1}" == "7" ]]; then
        msg="--> world writable"
    fi

    # Detect SUID
    if [[ "$perms" == *s* || "$perms" == *S* ]]; then
        msg="--> suid/sgid set"
    fi

    # Detect sticky bit
    if [[ "$perms" == *t ]]; then
        msg="--> sticky bit"
    fi

    printf "%-40s %-12s %-10s %-10s %s\n" "$file" "$perms" "$owner" "$group" "$msg"
done

