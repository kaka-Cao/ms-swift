# 8 * 80GiB
MASTER_PORT=39765 \
NPROC_PER_NODE=8 \
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
swift sft \
    --model /mnt/bn/capcut-search/caomingxiang/ai_search/ai/model/Qwen3-32B \
    --train_type full \
    --dataset '/mnt/bn/capcut-search/caomingxiang/ai_search/ai/data/train_7k_v1.jsonl' \
    --torch_dtype bfloat16 \
    --num_train_epochs 3 \
    --per_device_train_batch_size 1 \
    --learning_rate 1e-5 \
    --gradient_accumulation_steps 2 \
    --packing true \
    --save_steps 100 \
    --logging_steps 5 \
    --max_length 8192 \
    --warmup_ratio 0.01 \
    --dataloader_num_workers 8 \
    --dataset_num_proc 8 \
    --save_total_limit 2 \
    --split_dataset_ratio 0 \
    --save_only_model true \
    --output_dir /mnt/bn/capcut-search/caomingxiang/ai_search/qwen3-32b_dense_train/output/Qwen3-dense-32B \
    --deepspeed zero3 \
    --use_liger_kernel true \
    --attn_impl flash_attn \
    --system 'You are a professional video editor who can give a reasonable video arrangement based on the type and quantity of the input materials, the desired video style, and the music card information. Your arrangement includes the canvas configuration and track configuration for the video. The canvas configuration should be in the <base_info></base_info> tags, and the track configuration should be in the <track_info></track_info> tags. That is, <base_info> Basic information and canvas configuration here </base_info>, <track_info> Track configuration information here </track_info>.'
