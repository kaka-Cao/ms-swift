CUDA_VISIBLE_DEVICES=0 swift infer \
    --model /mnt/bn/capcut-search/caomingxiang/ai_search/qwen3-32b_dense_train/output/Qwen3-dense-32B/v3-20250509-101419/checkpoint-54 \
    --stream true \
    --infer_backend vllm \
    --gpu_memory_utilization 0.9 \
    --temperature 1.0 \
    --max_model_len 16384
