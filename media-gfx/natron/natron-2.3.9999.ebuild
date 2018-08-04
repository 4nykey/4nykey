# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit flag-o-matic qmake-utils python-single-r1 vcs-snapshot toolchain-funcs xdg
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/NatronGitHub/${PN}.git"
	EGIT_BRANCH="RB-${PV%.*}"
	inherit git-r3
else
	MY_PV="a0979fe"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	MY_OFX='openfx-4fc7b53'
	MY_SEQ='SequenceParsing-15bbe60'
	MY_TIN='tinydir-3aae922'
	MY_MCK='google-mock-17945db'
	MY_TST='google-test-50d6fc3'
	SRC_URI="
		mirror://githubcl/NatronGitHub/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/NatronGitHub/${MY_OFX%-*}/tar.gz/${MY_OFX##*-}
		-> ${MY_OFX}.tar.gz
		mirror://githubcl/NatronGitHub/${MY_SEQ%-*}/tar.gz/${MY_SEQ##*-}
		-> ${MY_SEQ}.tar.gz
		mirror://githubcl/NatronGitHub/${MY_TIN%-*}/tar.gz/${MY_TIN##*-}
		-> ${MY_TIN}.tar.gz
		test? (
			mirror://githubcl/NatronGitHub/${MY_MCK%-*}/tar.gz/${MY_MCK##*-}
			-> ${MY_MCK}.tar.gz
			mirror://githubcl/NatronGitHub/${MY_TST%-*}/tar.gz/${MY_TST##*-}
			-> ${MY_TST}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
fi
MY_OC="OpenColorIO-Configs_557b981"
SRC_URI+="
	mirror://githubcl/NatronGitHub/${MY_OC%%_*}/tar.gz/${MY_OC#*_}
	-> ${MY_OC}.tar.gz
"
RESTRICT="primaryuri"

DESCRIPTION="Open-source video compositing software"
HOMEPAGE="https://natron.fr"

LICENSE="GPL-2+ doc? ( CC-BY-SA-4.0 )"
SLOT="0"
IUSE="c++11 debug doc gmic openmp pch test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost
	media-libs/fontconfig
	dev-libs/expat
	x11-libs/cairo[static-libs]
	dev-python/pyside:0[X,opengl,${PYTHON_USEDEP}]
	dev-python/shiboken:0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	doc? ( dev-python/sphinx )
"
RDEPEND="
	${RDEPEND}
	~media-plugins/openfx-io-${PV}
	~media-plugins/openfx-misc-${PV}
	~media-plugins/openfx-arena-${PV}
	gmic? ( ~media-plugins/openfx-gmic-${PV} )
"

pkg_pretend() {
	use openmp && tc-check-openmp
}

src_unpack() {
	[[ -z ${PV%%*9999} ]] && git-r3_src_unpack
	vcs-snapshot_src_unpack
}

src_prepare() {
	use pch && append-flags -Winvalid-pch

	default

	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_OFX}/* "${S}"/libs/OpenFX
		mv "${WORKDIR}"/${MY_SEQ}/* "${S}"/libs/SequenceParsing
		mv "${WORKDIR}"/${MY_TIN}/* "${S}"/libs/SequenceParsing/tinydir
		if use test; then
			mv "${WORKDIR}"/${MY_MCK}/* "${S}"/Tests/${MY_MCK%-*}
			mv "${WORKDIR}"/${MY_TST}/* "${S}"/Tests/${MY_TST%-*}
		fi
	fi
	mv "${WORKDIR}"/${MY_OC} "${S}"/OpenColorIO-Configs

	sed \
		-e "s:@PKGCONFIG@:$(tc-getPKG_CONFIG):" \
		"${FILESDIR}"/config.pri > "${S}"/config.pri

	sed \
		-e '/INCLUDEPATH.*OSMESA_INCLUDES/d' \
		-i global.pri
}

src_configure() {
	local qmakeargs=(
		PREFIX=/usr
		BUILD_USER_NAME=Gentoo
		CONFIG+=custombuild
		CONFIG$(usex c++11 + -)=c++11
		CONFIG$(usex openmp + -)=openmp
		CONFIG$(usex pch - +)=nopch
		CONFIG$(usex debug - +)=noassertions
		CONFIG$(usex test - +)=notests
	)
	eqmake4 -r "${qmakeargs[@]}"
}

src_compile() {
	default
	use doc && \
		sphinx-build -b html Documentation/source html
}

src_install() {
	local DOCS=(
		{BUGS,CHANGELOG,CONTRIBUTING,README}.md CONTRIBUTORS.txt
		$(usex doc html '')
	)
	emake INSTALL_ROOT="${ED}" install
	einstalldocs
}

src_test() {
	cd "${S}"/Tests
	./Tests || die
}
