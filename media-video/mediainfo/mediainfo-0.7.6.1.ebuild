# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER="2.8"
inherit autotools wxwidgets

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediainfo.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/MediaInfo_${PV}_CLI_GNU_FromSource.tar.bz2"
S1="${WORKDIR}/MediaInfo_CLI_GNU_FromSource"
S="${S1}/MediaInfo/Project/GNU/CLI"

LICENSE="GPL-3 LGPL-3 ZLIB"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug unicode wxwindows"

DEPEND="
	sys-libs/zlib
	wxwindows? ( =x11-libs/wxGTK-${WX_GTK_VER}* )
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	unpack ${A}
	cd ${S}
	EPATCH_OPTS="-d${S1} ${EPATCH_OPTS}" epatch "${FILESDIR}"/${PN}-*.diff
	eautoreconf
}

src_compile() {
	econf \
		--enable-shared \
		$(use_enable debug) \
		$(use_enable unicode) \
		$(use_with wxwindows wxwidgets) \
		$(use_with wxwindows wx-config ${WX_CONFIG}) \
		|| die
	emake || die
}

src_install() {
	einstall || die
	dodoc ${S1}/MediaInfo*/History*.txt
	newdoc ${S1}/ZenLib/History.txt History.ZenLib.txt
}
