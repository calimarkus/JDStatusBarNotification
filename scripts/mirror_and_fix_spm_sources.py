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
import re
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
proj_dir = os.getenv("PROJECT_DIR")
print(f"PROJECT_DIR: {proj_dir}")

# verify src/dest dirs
sources_dir = checkedDir(os.path.join(proj_dir, "JDStatusBarNotification"))
swift_source = checkedFile(os.path.join(sources_dir, "Public/NotificationPresenter.swift"))
spm_mirror_dir_name = "spm_sources"
spm_mirror_dir = checkedDir(os.path.join(proj_dir, spm_mirror_dir_name))

# copy to dest dir
print(f"Copying sources to: {spm_mirror_dir_name}")
shutil.copytree(sources_dir, spm_mirror_dir, dirs_exist_ok=True)

# find public headers
public_headers = []
public_sources_dir = checkedDir(os.path.join(spm_mirror_dir, "Public"))
for file in os.listdir(public_sources_dir):
    current = os.path.join(public_sources_dir, file)
    name, ext = os.path.splitext(file)
    if os.path.isfile(current) and ext == ".h":
        public_headers.append(file)

# update imports
print(f"Found public headers: {public_headers}")
for header in public_headers:
    path = os.path.join(public_sources_dir, header)
    with open(path, "r+") as f:
        contents = f.read()
        contents, i = re.subn(r"<JDStatusBarNotification/(.*)>", '"\\1"', contents)
        if i > 0:
            print(f"replaced {i} imports in: {header}")
            f.seek(0)  # rewind
            f.truncate()  # empty file
            f.write(contents)
        f.close()
