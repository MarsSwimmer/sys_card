#!/bin/bash

# Main command
# 1. 根据进程命令获取所有进程
# 2. 根据进程名称聚合成不同的应用，部分应用存在调用其它应用的情况，因此需要枚举出来进行替换
# 3. 按照应用命令进行聚合，计算cpu占用率和内存占用情况 // 底层是group by的逻辑
# 4. 聚合后的数据格式化后输出
result=$(ps auxc | sed 's/WebKitWebProces/clash-nyanpasu/g; s/WebKitNetworkProcess/clash-nyanpasu/g; s/mihomo/clash-nyanpasu/g; s#steam[^ ]*#steam#; s#drawio[^ ]*#drawio#; s/zypak-sandbox/yesplaymusic/g; s#missioncenter[^ ]*#missioncenter#g; s#kworker[^ ]*#kworker#g; s#pipewire[^ ]*#pipewire#g; s#QtWebEngineProc#spark-store#g'  | awk -v cores=$(nproc) -F ' ' '{x[$11] += $3; y[$11] += $6} END {for (i in x) {printf "%s %f %f\n", i, x[i] / cores, y[i]/1024}}')
# 使用readarray命令将命令输出赋值给数组，并设置IFS为空字符串

readarray -t monitor_array_cpu < <(echo "$result" | sort -k2nr | head -n 5 | awk '{beyond=$3>1000; printf "%s %.2f %.2f %s\n", $1, $2, beyond?$3/1024:$3, beyond?"GB":"MB"}' |column -t)

readarray -t monitor_array_ram < <(echo "$result" | sort -k3nr | head -n 5 | awk '{beyond=$3>1000; printf "%s %.2f %.2f %s\n", $1, $2, beyond?$3/1024:$3, beyond?"GB":"MB"}' |column -t)

# 输出数组内容
# cpu占用top5的应用
for i in "${!monitor_array_cpu[@]}"; do
    cr set "cpu_top_$((i + 1))" "${monitor_array_cpu[$i]}"
done

# 输出数组内容
# ram占用top5的应用
for i in "${!monitor_array_ram[@]}"; do
    cr set "ram_top_$((i + 1))" "${monitor_array_ram[$i]}"
done

exit
