# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit java-pkg-2

DESCRIPTION="A software for the rendering of maps based on OpenStreetMap data"
HOMEPAGE="http://mapsforge.org"

LICENSE="LGPL-3"
SLOT="${PV}"
IUSE=""

DEPEND="
	>=virtual/jdk-1.7
"
RDEPEND="
	>=virtual/jre-1.7
"
JAVA_RM_FILES=(
	Applications/Android/Samples
	mapsforge-map-android
	mapsforge-map-android-extras
)
JAVA_RM_FILES=( ${JAVA_RM_FILES[@]/%/\/build.gradle} )

my_grdlw() {
	sh ./gradlew --gradle-user-home "${S}"/homedir/.gradle ${@} || die
}

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	my_grdlw jar
}

src_test() {
	my_grdlw test
}

src_install() {
	default
	local _j=(
		mapsforge-core
		mapsforge-map
		mapsforge-map-awt
		mapsforge-map-reader
		mapsforge-map-writer
		SwingMapViewer
	)
	for _j in ${_j[@]}; do
		java-pkg_newjar ${_j}/build/libs/${_j}-${PV}.jar ${_j}.jar
	done
	java-pkg_dolauncher SwingMapViewer-${SLOT} --jar SwingMapViewer.jar
}
