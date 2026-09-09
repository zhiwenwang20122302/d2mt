#!/usr/bin/env bash
# ------------------------------------------------------------------------------------------------
# Deformable DETR
# Copyright (c) 2020 SenseTime. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 [see LICENSE for details]
# ------------------------------------------------------------------------------------------------
# Modified from https://github.com/chengdazhi/Deformable-Convolution-V2-PyTorch/tree/pytorch_1.0.0
# ------------------------------------------------------------------------------------------------

# [2026-03-27] 修改说明：
# 编译 CUDA 扩展时报错：
#   fatal error: cuda_runtime_api.h: No such file or directory
# 原因：未设置 CUDA 环境变量，导致编译器找不到 CUDA 头文件
# 处理：新增 CUDA_HOME / PATH / LD_LIBRARY_PATH 配置
# 影响范围：仅影响编译阶段，其余逻辑保持不变
# ------------------------------------------------------------------------------------------------
# add 2026.3.27: fix CUDA headers not found during build
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

python setup.py build install

# [2026-03-27] Note:
# test.py can run successfully, and all forward/gradient checks pass.
# Current environment raises a NumPy compatibility warning because some
# compiled modules were built against NumPy 1.x while runtime NumPy is 2.0.2.
# If this causes later runtime issues, downgrade NumPy to < 2.
pip install "numpy<2"
