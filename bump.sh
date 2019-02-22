#!/bin/bash

version=v$(wget -q -O - https://github.com/SimonKagstrom/kcov/releases \
		 | grep -o -E '/SimonKagstrom/kcov/archive/v[[:digit:]]+.tar.gz' \
		 | grep -o -E '[[:digit:]]+' \
		 | sort -n -r \
		 | head -n 1)

msg="Trigger Travis build for Kcov ${version}"

echo "${msg}"

git commit --allow-empty -m "${msg}"
git tag ${version}
git push --tags -f origin HEAD:master
