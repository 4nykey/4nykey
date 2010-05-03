# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools wxwidgets subversion

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediainfo.sourceforge.net"
ESVN_REPO_URI="https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfo/trunk"
ESVN_PATCHES="${FILESDIR}"/${PN}*.diff
ESVN_BOOTSTRAP="eautoreconf"
S="${WORKDIR}"

LICENSE="GPL-3 LGPL-3 ZLIB"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug unicode wxwidgets curl libmms minimal"

WX_GTK_VER="2.8"
DEPEND="
	sys-libs/zlib
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )
	curl? ( net-misc/curl )
	libmms? ( media-libs/libmms )
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
	use wxwidgets && need-wxwidgets unicode
}

src_unpack() {
	subversion_fetch ${ESVN_REPO_URI} MediaInfo
	ESVN_PROJECT="mediainfolib" subversion_fetch\
		https://mediainfo.svn.sourceforge.net/svnroot/mediainfo/MediaInfoLib/trunk\
		MediaInfoLib
	ESVN_PROJECT="zenlib" subversion_fetch\
		https://zenlib.svn.sourceforge.net/svnroot/zenlib/ZenLib/trunk\
		ZenLib
}

src_prepare() {
	local _subdirs="ZenLib/Project/GNU/Library \
		MediaInfoLib/Project/GNU/Library \
		MediaInfo/Project/GNU/CLI \
		$(use wxwidgets && echo MediaInfo/Project/GNU/GUI)"

	cat <<EOF >"${S}"/configure.ac
AC_INIT(${PN},${PV})
AC_CONFIG_SUBDIRS(${_subdirs})
AM_INIT_AUTOMAKE(${PN},${PV})
AC_OUTPUT(Makefile)
EOF

	cat <<EOF >"${S}"/Makefile.am
SUBDIRS = ${_subdirs}
EOF

	subversion_src_prepare
}

src_configure() {
	econf \
		--enable-staticlibs \
		--enable-visibility \
		--disable-option-checking \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable unicode) \
		$(use_enable minimal minimize-size) \
		$(use_with curl libcurl) \
		$(use_with libmms) \
		$(use_with wxwidgets) \
		$(use_with wxwidgets wx-gui) \
		$(use_with wxwidgets wx-config ${WX_CONFIG})
}

src_install() {
	dobin MediaInfo/Project/GNU/CLI/mediainfo
	use wxwidgets && dobin MediaInfo/Project/GNU/GUI/mediainfo-gui
	dodoc MediaInfo/History_CLI.txt MediaInfo/Release/ReadMe_CLI_Linux.txt\
		  MediaInfoLib/*.txt MediaInfoLib/Release/*_Linux.txt
}
