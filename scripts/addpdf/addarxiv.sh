#!/bin/bash

output=$(python read-arxiv.py "$1")
url=$(echo $output | jq .url)
title=$(echo $output | jq .title)

./addpdf.sh "$url" "$title"
