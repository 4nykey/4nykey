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

my_grdlw() {
	sh ./gradlew \
		--gradle-user-home "${S}"/homedir/.gradle \
		--configure-on-demand \
		${@} || die
}

src_prepare() {
	default
	java-pkg-2_src_prepare
	sed -e '/android/d' -i "${S}"/settings.gradle
	find -ipath '*android*/build.gradle' -delete
}

src_compile() {
	my_grdlw jar
}

src_test() {
	my_grdlw test
}

src_install() {
	default
	local _j
	find "${S}" -name '*.jar' -! -path '*gradle*'|while read _j; do
		java-pkg_newjar ${_j} $(basename ${_j} "-${SLOT}.jar").jar
	done
}
