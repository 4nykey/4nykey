# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER="2.8"
inherit subversion autotools wxwidgets confutils

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediainfo.sourceforge.net"
ESVN_REPO_URI="https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfo/trunk"
ESVN_PATCHES="${PN}-*.diff"
S="${WORKDIR}"
S1="${WORKDIR}/MediaInfo/Project/GNU/CLI"
S2="${WORKDIR}/MediaInfo/Project/GNU/GUI"

LICENSE="GPL-3 LGPL-3 ZLIB"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug unicode wxwindows X"

DEPEND="
	sys-libs/zlib
	wxwindows? ( =x11-libs/wxGTK-${WX_GTK_VER}* )
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
	confutils_use_depend_all X wxwindows
	if use X; then
		confutils_require_built_with_all "=x11-libs/wxGTK-${WX_GTK_VER}*" X
	fi
}

src_unpack() {
	mkdir -p ${S}/{MediaInfo,MediaInfoLib,ZenLib}
	subversion_fetch ${ESVN_REPO_URI} MediaInfo
	ESVN_PROJECT="mediainfolib" subversion_fetch\
		https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfoLib/trunk\
		MediaInfoLib
	ESVN_PROJECT="zenlib" subversion_fetch\
		https://zenlib.svn.sourceforge.net/svnroot/zenlib/ZenLib/trunk\
		ZenLib
	subversion_bootstrap
	cd ${S1}
	eautoreconf

	if use X; then
		cd ${S2}
		eautoreconf
	fi
}

src_compile() {
	cd ${S1}
	econf \
		--enable-shared \
		$(use_enable debug) \
		$(use_enable unicode) \
		$(use_with wxwindows wxwidgets) \
		$(use_with X wx-gui) \
		$(use_with wxwindows wx-config ${WX_CONFIG}) \
		|| die
	emake || die

	if use X; then
		cd ${S2}
		econf \
			--enable-shared \
			$(use_enable debug) \
			$(use_enable unicode) \
			$(use_with wxwindows wxwidgets) \
			|| die
		emake || die
	fi
}

src_install() {
	emake DESTDIR="${D}" -C ${S1} install || die
	use X && emake DESTDIR="${D}" -C ${S2} install || die
	dodoc MediaInfo/History*.txt MediaInfoLib/*.txt MediaInfoLib/Release/ReadMe.Linux.txt
	newdoc MediaInfo/Release/ReadMe.Linux.txt ReadMe.CLI.txt
}
