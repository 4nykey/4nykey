# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER="2.8"
inherit subversion autotools wxwidgets confutils

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediainfo.sourceforge.net"
ESVN_REPO_URI="https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfo/trunk"
S="${WORKDIR}"
S0="${S}/ZenLib/Project/GNU/Library"
S1="${S}/MediaInfoLib/Project/GNU/Library"
S2="${S}/MediaInfo/Project/GNU/CLI"
S3="${S}/MediaInfo/Project/GNU/GUI"

LICENSE="GPL-3 LGPL-3 ZLIB"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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
	subversion_fetch ${ESVN_REPO_URI} MediaInfo
	ESVN_PROJECT="mediainfolib" subversion_fetch\
		https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfoLib/trunk\
		MediaInfoLib
	ESVN_PROJECT="zenlib" subversion_fetch\
		https://zenlib.svn.sourceforge.net/svnroot/zenlib/ZenLib/trunk\
		ZenLib
	for d in ${S0} ${S1} ${S2}; do
		cd ${d} && eautoreconf
	done

	if use X; then
		cd ${S3}
		eautoreconf
	fi
}

src_compile() {
	local myconf="
			--disable-static \
			--enable-shared \
			--disable-option-checking \
			--disable-dependency-tracking \
			$(use_enable debug) \
			$(use_enable unicode) \
			$(use_with wxwindows wxwidgets) \
	"
	for d in ${S0} ${S1} ${S2}; do
		cd ${d}
		econf \
			${myconf} \
			$(use_with X wx-gui) \
			$(use_with wxwindows wx-config ${WX_CONFIG}) \
			|| die "econf failed in ${d}"
		emake || die "emake failed in ${d}"
	done

	if use X; then
		cd ${S3}
		econf \
			${myconf} \
			|| die "econf failed in ${S3}"
		emake || die "emake failed in ${S3}"
	fi
}

src_install() {
	for d in ${S0} ${S1} ${S2}; do
		emake DESTDIR="${D}" -C ${d} install || die
	done
	use X && emake DESTDIR="${D}" -C ${S3} install || die
	dodoc MediaInfo/History*.txt MediaInfoLib/*.txt MediaInfoLib/Release/ReadMe.Linux.txt
	newdoc MediaInfo/Release/ReadMe.Linux.txt ReadMe.CLI.txt
}
