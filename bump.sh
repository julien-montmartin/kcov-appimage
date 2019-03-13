#!/bin/bash

version=v$(wget -q -O - https://github.com/SimonKagstrom/kcov/releases \
		 | grep -o -E '/SimonKagstrom/kcov/archive/v[[:digit:]]+.tar.gz' \
		 | grep -o -E '[[:digit:]]+' \
		 | sort -n -r \
		 | head -n 1)

msg="Trigger Travis build for Kcov ${version}"

echo "${msg}"

cat > trampoline.txt <<EOF
url https://github.com/julien-montmartin/kcov-appimage/releases/download/${version}/kcov-x86_64.AppImage
output kcov-x86_64.AppImage
EOF

git add trampoline.txt
git commit -m "${msg}"
git tag ${version}
git push --tags -f origin HEAD:master
