# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Avidemux CLI"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
EGIT_REPO_URI="git://gitorious.org/avidemux2-6/avidemux2-6.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="
	nls vdpau
"

RDEPEND="
	~media-video/avidemux-core-${PV}:${SLOT}[vdpau=]
"
DEPEND="
	$RDEPEND
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

CMAKE_USE_DIR="${S}"/avidemux/cli

src_configure() { 
	local x mycmakeargs
	mycmakeargs="
		-DAVIDEMUX_SOURCE_DIR=${S}
		$(for x in ${IUSE}; do cmake-utils_use $x; done)
		$(cmake-utils_use nls GETTEXT)
	"
	cmake-utils_src_configure
}
