#!/bin/bash

# Main command
result=$(sensors | grep 'mem\|Package\ id\ 0' | cut -d+ -f2 | cut -dC -f1 | sed 's/.$//' | sed 'N;s/\n/ /')

# 数据写入缓存
cr set "sensors_result" "$result"

exit
