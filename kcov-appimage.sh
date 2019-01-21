#!/bin/bash


root=$(readlink -f .)
sources="${root}"/src
resources="${root}"/resources
build="${root}"/build
log="${root}"/log
appdir="${root}"/appdir


make_kcov() {

	cd "${sources}"

	if [ ! -f kcov-master.tar.gz ] ; then

		wget -O kcov-master.tar.gz https://github.com/SimonKagstrom/kcov/archive/master.tar.gz
	fi

	cd "${build}"

	tar -xzf "${sources}"/kcov-master.tar.gz

	cd kcov-master

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

	"${resources}"/appimagetool-x86_64.AppImage "${appdir}"
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
