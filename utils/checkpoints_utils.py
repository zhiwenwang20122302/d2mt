import torch
import copy
import os
from .distributed_utils import is_main_process, is_dist_avail_and_initialized


def resume_and_load(model, ckpt_path, device):
    print("Loading checkpoints from", ckpt_path)
    checkpoints = torch.load(ckpt_path, map_location=device)
    if 'model' in checkpoints.keys() and 'optimizer' in checkpoints.keys():
        checkpoints = convert_official_ckpt(checkpoints, model.state_dict())
    missing_keys, unexpected_keys = model.load_state_dict(checkpoints)
    print("Missing keys:", missing_keys)
    print("Unexpected keys:", unexpected_keys)
    return model

## 更新 2026.3.15
def save_ckpt(model, save_path, distributed=False):
    if is_main_process(): #主进程保存模型
        os.makedirs(os.path.dirname(save_path), exist_ok=True)
        print("Saving checkpoints to", save_path)
        state_dict = model.state_dict() if not distributed else model.module.state_dict()
        torch.save(state_dict, save_path)
    # 可选：保存完后再次同步，确保其他进程知道保存完成了（如果后续代码依赖文件存在）
    if is_dist_avail_and_initialized():
        torch.distributed.barrier()


def selective_reinitialize(model, reinit_ckpt, keep_modules):
    # print("Doing selective reinitialization. Parameters of the model will be reinitialized EXCEPT FOR:")
    for key in copy.deepcopy(list(reinit_ckpt.keys())):
        to_be_reinit = True
        for keep_module in keep_modules:
            if keep_module in key:
                to_be_reinit = False
                break
        if not to_be_reinit:
            reinit_ckpt.pop(key)
            # print(key)
    model.load_state_dict(reinit_ckpt, strict=False)
    return model


def convert_official_ckpt(checkpoints, state_dict):
    checkpoints = checkpoints['model']
    official_keys, new_keys = sorted(list(checkpoints.keys())), sorted(list(state_dict.keys()))
    new_state_dict = {}
    for k_official, k_new in zip(official_keys, new_keys):
        if not k_official.startswith('class'):
            new_state_dict[k_new] = checkpoints[k_official]
        else:
            print("Skipping", k_official)
            new_state_dict[k_new] = state_dict[k_new]
    return new_state_dict