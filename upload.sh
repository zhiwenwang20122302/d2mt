#!/bin/bash
git config --global user.name "15708418408"
git config --global user.email "15708418408@163.com"
# git config --global credential.helper store

# git status 能告诉你“你的分支领先/落后远程多少提交”。

# 远程拉下来，如果有冲突，自己会报错；不会直接覆盖的；
# 将本地的 master 分支设置为跟踪（track）远程仓库 origin 上的 master 分支。
# git branch --set-upstream-to=origin/master master
# 目的是为了
    # 执行 git pull 时，应该从哪个远程分支拉取；
    # 执行 git push 时，应该推送到哪个远程分支；
# 远程拉下来
# git pull origin/master master
# git branch --set-upstream-to=origin/master master

# git pull origin master #如果尚未设置上游，可显式指定
# git pull #最常见用法（在已设置上游的分支上）

git add configs
git add datasets
git add docs
git add models
git add utils
git add build_modules.py
git add engine.py
git add main.py
# git add pseudoLabel_analyzer.py
git add README.md
git add requirements.txt
git add *.sh
git add scripts

# git add project_three_level_indicator
# git add project_debug
# git add project_grouping_ablation
git add project_ReliablePseudoLabels
# git add project_debug_d2mt
# git add scripts
# git add project_multigroups
git add project_ddt
# git add project_ddtv2
# git add scripts

# git add Visualization/multi_folder_sync_stitcher.py
# git add Visualization/visualization.py
# git add Visualization/visualization.sh
# git add Visualization_rpl/multi_folder_sync_stitcher.py
# git add Visualization_rpl/visualization.py
# git add Visualization_rpl/visualization.sh

git commit -am "$(date "+%Y-%m-%d %H:%M:%S")"
# git remote add origin git@gitee.com:wang-zhiwen20122302/phdyolo.git
# git push -u origin master #首次推送新分支（设置上游）
git push #直接推送当前分支（已设置上游后）
# git push origin master:master

# git log #查看提交历史（日志）
# git log #基础用法
# git log --oneline #简洁格式（一行一条）：
# git log --oneline -3 #查看最近 N 次提交：
# git log --oneline --graph --all #带分支图（可视化分支合并）
# git log -- path/to/file.txt #查看某文件的修改历史
# git log --author="your-name" #按作者过滤：
# git status #查看工作区状态
# git status -s #简洁模式
# git status --untracked-files=no #不显示未跟踪文件（干净点）：
# git branch #列出所有分支
# git branch -a #查看所有分支（包括远程）
# git branch <branch-name> #创建新分支（不切换）
# # 创建并切换到新分支（推荐方式）
# git checkout -b <new-branch> # 方式1（传统）
# git switch -c <new-branch> # 方式2（Git 2.23+ 推荐）
# git branch -m <new-name> #重命名当前分支
# # 删除分支
# git branch -d <branch-name>   # 安全删除（仅当已合并）
# git branch -D <branch-name>   # 强制删除（未合并也删）
# git branch -v #查看分支的最新提交信息
# git branch --merged      # 已合并到当前分支的分支
# git branch --no-merged   # 尚未合并的分支（删除前小心！）

# 问题：配置了密钥，还是要输入密码
# 先确认远程地址是不是 SSH
# git remote -v
# origin  https://gitee.com/xxx/xxx.git (fetch)
# origin  https://gitee.com/xxx/xxx.git (push)
# 把远程地址改成 SSH
# git remote set-url origin git@gitee.com:你的用户名/你的仓库名.git
# git remote set-url origin git@gitee.com:wang-zhiwen20122302/cascade-mt.git