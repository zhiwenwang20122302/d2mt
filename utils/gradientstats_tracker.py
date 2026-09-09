import torch
from typing import Dict, Optional, Literal, Union
import copy
from .distributed_utils import is_main_process, all_gather, is_dist_avail_and_initialized

OpType = Literal['T','D2']

class GradientStatsTracker:
    def __init__(self, op, device):
        self._stats_dict: Dict[str, torch.Tensor] = {}
        self._stats_dict_tmp: Dict[str, torch.Tensor] = {}
        self._initialized = False
        self._op = op
        self._device = device
        
    def _initialize_buffers(self, model_ref: torch.nn.Module):
        count = 0
        for name, param in model_ref.named_parameters():
            if param.requires_grad:
                self._stats_dict[name] = torch.zeros_like(param.data, dtype=torch.float, device=self._device)
                count += 1
        if count == 0:
            raise ValueError("Reference model has no parameters requiring gradients!")
        self._stats_dict_tmp = copy.deepcopy(self._stats_dict)
        self._initialized = True
        print(f"Initialized {count} buffers.")

    def reset(self):
        for tensor in self._stats_dict.values():
            tensor.zero_()
        for tensor in self._stats_dict_tmp.values():
            tensor.zero_()
            
    def step(self, 
             model_t: Optional[torch.nn.Module] = None, 
             model_s: Optional[torch.nn.Module] = None):
        if not self._initialized:
            if model_t:
                self._initialize_buffers(model_t) 
            else:
                self._initialize_buffers(model_s)            
        
        if self._op == "T":
            for n, p in model_t.named_parameters():
                if p.grad is not None:
                    self._stats_dict_tmp[n].copy_(p.grad.abs())
        elif self._op == "D2":
            for n, p in model_t.named_parameters():
                if p.grad is not None:
                    self._stats_dict_tmp[n].copy_(p.grad.abs())
            for n, p in model_s.named_parameters():
                if p.grad is not None:
                    self._stats_dict_tmp[n].add_(-p.grad.abs())
                    self._stats_dict_tmp[n].abs_()
        else:
            raise ValueError('Invalid Groupby: ' + self._op)
            
        for k,v in self._stats_dict_tmp.items():
            self._stats_dict[k].add_(v)

    @property
    def stats_dict(self):
        return self._stats_dict