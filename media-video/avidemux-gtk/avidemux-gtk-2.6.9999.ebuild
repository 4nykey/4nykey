# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"
inherit cmake-utils l10n git-2

DESCRIPTION="Avidemux GTK"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
EGIT_REPO_URI="git://gitorious.org/avidemux2-6/avidemux2-6.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="
	nls sdl xv
"

RDEPEND="
	~media-video/avidemux-core-${PV}:${SLOT}[sdl=,xv=]
	x11-libs/gtk+:3
"
DEPEND="
	$RDEPEND
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

CMAKE_USE_DIR="${S}"/avidemux/gtk
PATCHES=("${FILESDIR}"/${P}*.diff)

rm_loc() {
	rm po/${1}.po
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
	"
		cmake-utils_src_configure
}
