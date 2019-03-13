# Kcov AppImage

An [AppImage](https://appimage.org) of [Kcov](https://github.com/SimonKagstrom/kcov) code coverage tool.

[![Build Status](https://travis-ci.com/julien-montmartin/kcov-appimage.svg?branch=master)](https://travis-ci.com/julien-montmartin/kcov-appimage)

Handy to use with Travis : Download and run this AppImage rather than rebuilding Kcov from sources on every build.

This kind of Bash script may help you to download the latest AppImage of Kcov from this repo :

```bash
getKcovAppImage() {

	trampoline=https://raw.githubusercontent.com/julien-montmartin/kcov-appimage/master/trampoline.txt
	curl -s ${trampoline} | curl -sLK -
	chmod +x ./kcov-x86_64.AppImage
	echo "Running AppImage of $(./kcov-x86_64.AppImage --version)"
}
```

Call `getKcovAppImage` and run `./kcov-x86_64.AppImage` with the command line you need for your project. See [this](https://github.com/julien-montmartin/ternary-tree) Rust repo for a working example.
