# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"
inherit cmake-utils l10n git-2

DESCRIPTION="Avidemux QT4"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
EGIT_REPO_URI="git://gitorious.org/avidemux2-6/avidemux2-6.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="
	nls opengl sdl vdpau xv
"

RDEPEND="
	~media-video/avidemux-core-${PV}:${SLOT}[sdl=,vdpau=,xv=]
	x11-libs/qt-gui:4
	opengl? ( x11-libs/qt-opengl:4 )
"
DEPEND="
	$RDEPEND
"

CMAKE_USE_DIR="${S}"/avidemux/qt4
PATCHES=("${FILESDIR}"/${P}*.diff)

rm_loc() {
	rm po/*_${1}.ts
}

src_prepare() {
	#epatch "${PATCHES[@]}"
	l10n_for_each_disabled_locale_do rm_loc
}

src_configure() { 
	local x mycmakeargs
	mycmakeargs="
		-DAVIDEMUX_SOURCE_DIR=${S}
		$(for x in ${IUSE}; do cmake-utils_use $x; done)
		$(cmake-utils_use nls GETTEXT)
		$(cmake-utils_use xv XVIDEO)
	"
	cmake-utils_src_configure
}
