#!/bin/bash
# 日志文件
LOG_FILE="quili.log"
# 进程名称
PROCESS_NAME="qclient-2.0.2.3-linux-amd64"

# 启动程序并清空日志文件
> "$LOG_FILE"

# 检查进程是否存在
if pgrep -f "$PROCESS_NAME" > /dev/null; then
    echo "$PROCESS_NAME 进程正在运行，继续监控..."
else
    echo "$PROCESS_NAME 进程不存在，准备启动..."

    ./qclient-2.0.2.3-linux-amd64 token mint all --config=.config > "$LOG_FILE" 2>&1 &
    echo "$PROCESS_NAME 启动成功"
fi

# 循环监控日志文件
while true; do
    # 初始化 error 计数器
    ERROR_COUNT=0
    # 读取日志文件，逐行处理
    while IFS= read -r line; do
        # 打印当前行
        echo "检测到日志行: $line"
        # 检查是否有 "level":"info"
        if [[ "$line" == *'"level":"info"'* ]]; then
            # 如果有 "level":"info"，重置 error 计数器
            ERROR_COUNT=0
            echo "检测到 info 级别日志，重置 error 计数器"
        fi
        # 检查是否有 "level":"error"
        if [[ "$line" == *'"level":"error"'* ]]; then
            # 增加 error 计数器
            ERROR_COUNT=$((ERROR_COUNT + 1))
            echo "检测到 error 级别日志，当前 error 计数器: $ERROR_COUNT"

            # 检查连续 error 出现的数量
            if [ "$ERROR_COUNT" -gt 5 ]; then
                # 杀死进程
                pkill -f "$PROCESS_NAME"
                echo "检测到连续 error 超过 5 次，已杀死进程 $PROCESS_NAME"
                
                # 清空日志文件
                > "$LOG_FILE"
                
                # 启动程序
                ./qclient-2.0.2.3-linux-amd64 token mint all --config=.config > "$LOG_FILE" 2>&1 &
                echo "$PROCESS_NAME 启动成功"
            fi
        fi
    done < <(tail -F "$LOG_FILE")  # 实时监控日志文件的变化

done
