#!/bin/bash

BASE_DIR="/mnt/bn/capcut-search/caomingxiang/ai_search/qwen3-32b_dense_train/output/Qwen3-dense-32B"

LOGDIRS=""
for dir in "$BASE_DIR"/v*; do
  runs_dir="$dir/runs"
  if [ -d "$runs_dir" ]; then
    name=$(basename "$dir")
    LOGDIRS="${LOGDIRS}${name}:${runs_dir},"
  fi
done

# 去掉最后的逗号
LOGDIRS=${LOGDIRS%,}

echo "启动 TensorBoard，logdir 参数为："
echo "$LOGDIRS"

# 启动 TensorBoard
tensorboard --logdir="$LOGDIRS" --port 6006 --host 0.0.0.0
echo "👉 如果你在 Arnold Cloud IDE，请在浏览器访问："
echo "   https://port-6006-arnold-proxy-i18n.tiktok-row.org${CODESPACES_PATH:-/}/"
