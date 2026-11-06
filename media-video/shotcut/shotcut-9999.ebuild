# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mltframework/${PN}.git"
else
	MY_PV="96a492f"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/mltframework/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org"

LICENSE="GPL-3+"
SLOT="0"
IUSE="jack vulkan"

DEPEND="
	>=media-libs/mlt-7.36:=[ffmpeg,frei0r,jack?,qt6,sdl,xml]
	sci-libs/fftw:=
	dev-qt/qtbase:6=[dbus,gui,opengl,sql,vulkan?,widgets,xml]
	dev-qt/qtmultimedia:6=
	dev-qt/qtdeclarative:6=[opengl,widgets]
	dev-qt/qtcharts:6=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-qt/qttools[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=( )
	[[ -n ${PV%%*9999} ]] && mycmakeargs+=(
		-DSHOTCUT_VERSION="${PV%%*_p*}"
	)
	cmake_src_configure
}
