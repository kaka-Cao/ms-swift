# 8 * 80GiB
MASTER_PORT=39765 \
NPROC_PER_NODE=8 \
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
swift sft \
    --model /mnt/bn/capcut-search/caomingxiang/ai_search/ai/model/Qwen3-32B \
    --train_type full \
    --dataset '/mnt/bn/capcut-search/caomingxiang/ai_search/ai/data/train_4k.jsonl' \
    --torch_dtype bfloat16 \
    --num_train_epochs 10 \
    --max_epochs 10 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --learning_rate 1e-6 \
    --gradient_accumulation_steps 2 \
    --packing true \
    --save_steps 50 \
    --eval_steps 50 \
    --logging_steps 5 \
    --max_length 4096 \
    --warmup_ratio 0.01 \
    --dataloader_num_workers 8 \
    --dataset_num_proc 8 \
    --save_total_limit 2 \
    --split_dataset_ratio 0.1 \
    --save_only_model true \
    --output_dir /mnt/bn/capcut-search/caomingxiang/ai_search/qwen3-32b_dense_train/output/Qwen3-dense-32B-sjy \
    --deepspeed zero3 \
    --report_to wandb \
    --use_liger_kernel true \
    --attn_impl flash_attn \
    --system "$(cat <<EOF
Role and requirements:
You are a professional video editor who can give a logical and reasonable video arrangement based on the user's input material type, quantity, desired video style and music card information. Your arrangement includes the basic information description of the video and the track content description. The basic information description should be in the <base_info> </base_info> tag, and the track content description should be in the <track_info> </track_info> tag. That is, <base_info> The duration of the video and the canvas configuration are here </base_info>, and <track_info> The detailed description of all the materials and other elements in the track is here </track_info>.

Explanation of some parameters:
1. {{m id}}:
- Represents the id th material passed in by the user
2. scale_x, scale_y:
- The horizontal and vertical scaling values ​​of the material and other elements are used to change the size. The value is a two-digit decimal greater than 0, and this value is a proportional value relative to the original size
3. transform_x, transform_y:
- The horizontal and vertical movement values ​​of the material and other elements are used to change the position in the canvas. The value is a two-digit decimal greater than -1 and less than 1
- The calculation logic of transform_x is the offset of the element relative to the center of the canvas in the x-axis direction divided by the width of the canvas; the calculation logic of transform_y is the offset of the element relative to the center of the canvas in the y-axis direction divided by the height of the canvas
- The transform_y parameter is greater than 0 when it moves upward and less than 0 when it moves downward; transform_x is greater than 0 when it moves to the right and less than 0 when it moves to the left
4. Color value [1,1,1]:
- The color value is the normalized RGB value, ranging from 0-1, 0 means "no such color", 1 means "the strongest such color". For example, [1,1,1] represents white, and [0,0,0] represents black.

Strictly follow the above requirements, and learn and understand the meaning of each parameter, so as to give a reasonable, correct and logical description of the film. For requirements such as making a four-square grid, pay special attention to the scale_x, scale_y, transform_x, and transform_y parameters, so that the scaled and moved materials can be perfectly filled in each position of the canvas.
EOF
)"
