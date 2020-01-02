#!/bin/bash
# Copyright (C) 2019 baalajimaestro
#
# Licensed under the Raphielscape Public License, Version 1.b (the "License");
# you may not use this file except in compliance with the License.
#

echo "***BuildBot***"
echo $TELEGRAM_TOKEN >/tmp/tg_token
echo $TELEGRAM_CHAT >/tmp/tg_chat
echo $GITHUB_TOKEN >/tmp/gh_token

useradd -m -d /home/ci ci
useradd -g ci wheel
chmod +x github-release
chmod +x telegram
mkdir -p ~/bin
wget 'https://storage.googleapis.com/git-repo-downloads/repo' -P ~/bin
chmod +x ~/bin/repo
export PATH=~/bin:$PATH
export USE_CCACHE=1
bash ./build.sh
