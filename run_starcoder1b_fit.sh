# need to give deepspeed config file as argument
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please give deepspeed config file as argument"
    exit 1
fi
python3 -m torch.distributed.launch \
        --nproc_per_node 8 \
        train.py \
        --deepspeed="$1" \
        --model_path="bigcode/starcoderbase-1b" \
        --no_custom_tokenizer \
        --dataset_name="nuprl/ts-training" \
        --dataset_revision="v1.1p1" \
        --total_tokens=7203565775 \
        --fim_rate 1 \
        --fim_spm_rate 0.5 \
        --output_dir="./model_starcoder_1b_fit_8k" \
        --seq_length 8192 \
        --epochs 10 \
        --batch_size 2 \
        --gradient_accumulation_steps 8 \
        --learning_rate 2e-5 \
        --num_warmup_steps 10 \
        --num_workers=$(expr $(nproc --all) - 4) \
        --no_fp16 \
        --eval_freq 0.01 \
        --save_freq 0.01 \
        --bf16 \
        --perc_valid_set 0.0001 \
        --save_total_limit 40
