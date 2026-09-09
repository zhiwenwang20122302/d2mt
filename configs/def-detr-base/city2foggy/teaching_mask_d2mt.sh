#!/bin/bash

run_d2mt(){
    GROUPEDBY="D2"
    FIXUPDATEITER=2

    N_GPUS=4
    BATCH_SIZE=8
    DATA_ROOT=./data
    OUTPUT_ROOT=./outputs/def-detr-base/city2foggy
    OUTPUT_DIR=${OUTPUT_ROOT}/teaching_mask_d2mt

    mkdir -p $OUTPUT_DIR 

    CUDA_VISIBLE_DEVICES=0,1,2,3 OMP_NUM_THREADS=4 torchrun \
    --rdzv_endpoint localhost:26503 \
    --nproc_per_node=${N_GPUS} \
    main.py \
    --backbone resnet50 \
    --num_encoder_layers 6 \
    --num_decoder_layers 6 \
    --num_classes 9 \
    --dropout 0.0 \
    --data_root ${DATA_ROOT} \
    --source_dataset cityscapes \
    --target_dataset foggy_cityscapes \
    --batch_size ${BATCH_SIZE} \
    --eval_batch_size ${BATCH_SIZE} \
    --lr 2e-4 \
    --lr_backbone 2e-5 \
    --lr_linear_proj 2e-5 \
    --alpha_ema 0.9996 \
    --alpha_aema 0.997 \
    --epoch 30 \
    --epoch_lr_drop 80 \
    --student_reset_interval 12 \
    --mode teaching_mask \
    --threshold 0.4 \
    --threshold_s 0.5 \
    --fix_update_iter ${FIXUPDATEITER} \
    --only_class_loss \
    --grouped_by ${GROUPEDBY} \
    --output_dir ${OUTPUT_DIR} \
    --resume ${OUTPUT_ROOT}/source_only/city2foggy_source_only_29_53.pth | tee  ${OUTPUT_DIR}/logfile
    wait
}

run_d2mt