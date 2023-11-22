#!/bin/bash

cd ~/.files

brew bundle dump --force --file=~/.files/Brewfile

git add -A
git commit -m "$(date '+%Y-%m-%d %H:%M:%S'): Automated Update"
git push

