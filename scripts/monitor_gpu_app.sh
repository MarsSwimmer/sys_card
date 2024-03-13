#!/bin/bash

# Main command
result=$(amdgpu_top -n 1 --json)
# GPU概览
overview=$(echo $result | jq -r '.devices[] | (.VRAM."Total VRAM".value|tostring) +" "+ (.VRAM."Total VRAM Usage".value|tostring) + " " + (.gpu_activity.GFX.value|tostring)' | awk '{printf "%s %s %d %s\n", $1, $2, $2/$1*100, $3}')

# App GPU占用情况
# 使用readarray命令将命令输出赋值给数组，并设置IFS为空字符串
gpuResult=$(echo $result | jq -r '(.devices[] | (.fdinfo | .[] | "\(.name)\t\(.usage.GFX.value)\t\(.usage.VRAM.value)"))' | sed 's/WebKitWebProces/clash-nyanpasu/g; s/WebKitNetworkProcess/clash-nyanpasu/g; s/mihomo/clash-nyanpasu/g; s#steam[^ ]*#steam#; s#drawio[^ ]*#drawio#; s/zypak-sandbox/yesplaymusic/g; s#missioncenter[^ ]*#missioncenter#g; s#kworker[^ ]*#kworker#g; s#pipewire[^ ]*#pipewire#g' | awk '{x[$1] += $2; y[$1] += $3} END {for (i in x) {printf "%s %d %f\n", i, x[i], y[i]}}')

readarray -t monitor_array_gpu < <(echo "$gpuResult" | sort -k2nr | head -n 5 | awk '{beyond=$3>1000; printf "%s %.2f %.2f %s\n", $1, $2, beyond?$3/1024:$3, beyond?"GB":"MB"}' | column -t)

readarray -t monitor_array_vram < <(echo "$gpuResult" | sort -k3nr | head -n 5 | awk '{beyond=$3>1000; printf "%s %.2f %.2f %s\n", $1, $2, beyond?$3/1024:$3, beyond?"GB":"MB"}' | column -t)

# 输出数组内容
# 11~15行展示gpu占用top5的应用
for i in "${!monitor_array_gpu[@]}"; do
    cr set "gpu_top_$((i + 1))" "${monitor_array_gpu[$i]}"
done

# 16~20行展示vram占用top5的应用
for i in "${!monitor_array_vram[@]}"; do
    cr set "vram_top_$((i + 1))" "${monitor_array_vram[$i]}"
done

# GPU概览
cr set "gpu_overview" "$overview"
