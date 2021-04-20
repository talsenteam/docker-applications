#!/bin/bash

git init \
> /dev/null

git config \
--local \
user.email "theia@localhost"
git config \
--local \
user.name "Theia IDE"

git add \
. \
> /dev/null
git commit \
-m "Initial commit." \
> /dev/null
