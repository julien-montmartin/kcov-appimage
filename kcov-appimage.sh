#!/bin/bash

root=$(readlink -f .)
sources=${root}/src
resources=${root}/resources
build=${root}/build
log=${root}/log
appdir=${root}/appdir

version=v$(wget -q -O - https://github.com/SimonKagstrom/kcov/releases \
			  | grep -o -E '/SimonKagstrom/kcov/archive/v[[:digit:]]+.tar.gz' \
			  | grep -o -E '[[:digit:]]+' \
			  | sort -n -r \
			  | head -n 1)

make_kcov() {

	cd "${sources}"

	if [ ! -f kcov-${version}.tar.gz ] ; then

		wget -O kcov-${version}.tar.gz https://github.com/SimonKagstrom/kcov/archive/${version}.tar.gz
	fi

	cd "${build}"

	tar -xzf "${sources}"/kcov-${version}.tar.gz

	cd kcov-*

	cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr

	make kcov

	make install DESTDIR="${appdir}"

	cd "${root}"
}


describe_appimage() {

	mkdir -p "${appdir}"/usr/share/applications

	mkdir -p  "${appdir}"/usr/share/icons/hicolor/256x256/apps

	#Blanket by Alex Muravev from the Noun Project
	cp "${resources}"/blanket.png  "${appdir}"/usr/share/icons/hicolor/256x256/apps/kcov.png

	cat > "${appdir}"/usr/share/applications/kcov.desktop <<EOF
[Desktop Entry]
Name=kcov
Icon=kcov
Type=Application
Exec=kcov
Categories=Development;
Terminal=true
Comment=kcov code coverage tool ${version}
EOF

	cat "${appdir}"/usr/share/applications/kcov.desktop
}


gather_dependencies() {

	cd "${resources}"

	if [ ! -f linuxdeploy-x86_64.AppImage ] ; then

		wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
		chmod +x linuxdeploy-x86_64.AppImage
	fi

	cd "${root}"

	"${resources}"/linuxdeploy-x86_64.AppImage --appdir ""${appdir}""
}


make_appimage() {

	cd "${resources}"

	if [ ! -f appimagetool-x86_64.AppImage ] ; then

		wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
		chmod a+x appimagetool-x86_64.AppImage
	fi

	cd "${root}"

	ARCH=x86_64 "${resources}"/appimagetool-x86_64.AppImage "${appdir}"

	#mv kcov*.AppImage kcov-${version}-x86_64.AppImage
}


appimage_done() {

	ls -lh "${root}"/kcov-*.AppImage
}


rm -Rf "${build}" "${appdir}" "${log}" kcov-*.AppImage
mkdir -p "${build}" "${appdir}" "${log}" "${sources}" "${resources}"


for todo in make_kcov describe_appimage gather_dependencies make_appimage appimage_done; do

	cat <<EOF


#############################################################
#
# ${todo}
#
#############################################################

EOF

	${todo} 2>&1 | tee "${log}"/${todo}.log
done
