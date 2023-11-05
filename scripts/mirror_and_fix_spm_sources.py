#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# A script to copy sources files for SPM usage.
#
# Reasoning:
# - SPM doesn't support mixed language targets.
# - Furthermore, SPM is unhappy with library style imports.
# - So we mirror all source files, fix up the imports and use that for SPM.
#

import os
import shutil
import sys

def checkedDir(dir):
    if not os.path.isdir(dir):
        sys.exit(f"ERROR: Couldn't find dir: {dir}")
        return Null
    return dir

def checkedFile(path):
    if not os.path.isfile(path):
        sys.exit(f"ERROR: Couldn't find file: {path}")
        return Null
    return dir

# get proj dir
proj_dir = os.getenv('PROJECT_DIR')
print(f'PROJECT_DIR: {proj_dir}')

# verify src/dest dirs
sources_dir = checkedDir(os.path.join(proj_dir, 'JDStatusBarNotification'))
swift_source = checkedFile(os.path.join(sources_dir, 'Public/NotificationPresenter.swift'))
spm_mirror_dir_name = '.spm_mirror'
spm_mirror_dir = checkedDir(os.path.join(proj_dir, spm_mirror_dir_name))

# copy to dest dir
print(f'Copying sources to: {spm_mirror_dir_name}')
shutil.copytree(sources_dir, spm_mirror_dir, dirs_exist_ok=True)


# for file in os.listdir(sources_dir):
#     current = os.path.join(sources_dir, file)
#     if os.path.isdir(current):
#         print(f"found dir {current}")

sys.exit("done")
