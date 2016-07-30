# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="Mobile Atlas Creator"
EANT_BUILD_TARGET="build_mapsources create_jar"
WANT_ANT_TASKS="ant-contrib"
if [[ -z ${PV%%*9999} ]]; then
	MY_MF="0.6.1"
	MY_SQ="3.8.11"
	inherit subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/mobac/code/trunk/${PN^^}"
else
	MY_MF="0.6.0"
	MY_SQ="3.7.15"
	SRC_URI="${PN}/${MY_PN}/${PN^^} ${PV:0:3}/${MY_PN} ${PV/_beta/ beta }"
	SRC_URI="
		mirror://sourceforge/${SRC_URI// /%20}%20src.zip -> ${P}_src.zip
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Mobile Atlas Creator creates offline atlases for mobile GPS apps"
HOMEPAGE="http://mobac.sf.net"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

MY_JDEPS=(
	dev-db/db-je:3.3
	dev-java/ant-contrib:0
	dev-java/bsh:0
	dev-java/commons-codec:0
	dev-java/commons-io:1
	dev-java/commons-lang:3.1
	dev-java/itext:5
	dev-java/javapng:0
	dev-java/jtidy:0
	dev-java/kxml:2
	dev-java/log4j:0
	dev-java/mapsforge:${MY_MF}
	dev-java/simmetrics:0
	dev-java/svgsalamander:0
	dev-java/sqlite-jdbc:${MY_SQ}
	dev-java/sun-jai-bin:0
)
DEPEND="
	>=virtual/jdk-1.7
	${MY_JDEPS[@]}
"
RDEPEND="
	>=virtual/jre-1.7
	${MY_JDEPS[@]}
"
PATCHES=(
	"${FILESDIR}"/${PN}-systemlibs.diff
	"${FILESDIR}"/${PN}-userdir.diff
)
DOCS=( CHANGELOG.txt )

src_prepare() {
	default

	java-pkg-2_src_prepare
	ebegin "Cleaning ..."
	java-pkg_clean >/dev/null
	eend $?
	java-ant_rewrite-classpath

	local _p=( ${MY_JDEPS[@]#*/} )
	_p=( ${_p[@]%:0} )
	_p="${_p[@]//:/-}"
	_p="${_p// /,}"
	java-pkg_jar-from --build-only --into "${S}"/lib ${_p}
	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjars --with-dependencies ${_p})"
}

src_install() {
	java-pkg_dojar Mobile_Atlas_Creator.jar
	java-pkg_dolauncher ${PN} Mobile_Atlas_Creator.jar
	insinto ${JAVA_PKG_JARDEST}
	doins -r mapsources log4j.xml README.HTM
	[[ -e world.map ]] && doins world.map

	local _s
	for _s in 16 32 48; do
		newicon -s ${_s} \
			src/main/resources/mobac/resources/images/mobac${_s}.png ${PN}.png
	done
	newicon src/main/resources/mobac/resources/images/mobac48.png ${PN}.png
	make_desktop_entry ${PN}

	default
}
