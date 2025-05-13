CUDA_VISIBLE_DEVICES=0 swift infer \
    --model /mnt/bn/capcut-search/caomingxiang/ai_search/qwen3-32b_dense_train/output/Qwen3-dense-32B/v10-20250513-064443/checkpoint-186 \
    --stream true \
    --infer_backend vllm \
    --gpu_memory_utilization 0.9 \
    --temperature 0.6 \
    --repetition_penalty 1 \
    --max_model_len 4096
