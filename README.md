# Kcov AppImage

An [AppImage](https://appimage.org) of [Kcov](https://github.com/SimonKagstrom/kcov) code coverage tool.

[![Build Status](https://travis-ci.com/julien-montmartin/kcov-appimage.svg?branch=master)](https://travis-ci.com/julien-montmartin/kcov-appimage)

Handy to use with Travis : Download and run this AppImage rather than rebuilding Kcov from sources on every build.

This kind of Bash script may help you to download the latest AppImage of Kcov from this repo :

```bash
getKcovAppImage() {

	repo=julien-montmartin/kcov-appimage
	html=$(wget -q -O - https://github.com/${repo}/releases/latest)
	release=$(grep -o -E /${repo}/releases/download/[^/]+/kcov-[^.]+\\.AppImage <<< ${html})
	url=https://github.com/${release}
	kcov=kcov.AppImage

	wget -q -O ${kcov} ${url}
	chmod +x ${kcov}

	cmd="./${kcov} --version"
	ver=$(eval ${cmd})

	echo "Running ${cmd} says ${ver}"
}
```

Call `getKcovAppImage` and run `./kcov.AppImage` with the command line you need for your project. See [this](https://github.com/julien-montmartin/ternary-tree) Rust repo for a working example.
