# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvtoolnix/mkvtoolnix-0.9.5.ebuild,v 1.2 2004/09/02 11:39:34 mholzer Exp $

inherit eutils wxwidgets subversion

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="http://www.bunkus.org/videotools/mkvtoolnix"
#SRC_URI="${HOMEPAGE}/sources/${P}.tar.bz2"
ESVN_REPO_URI="http://svn.bunkus.org/mosu/trunk/prog/video/mkvtoolnix"
ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk2 X oggvorbis unicode flac lzo"

DEPEND=">=media-libs/libmatroska-0.7.5
	vorbis? ( media-libs/libvorbis )
	flac? ( >=media-libs/flac-1.1.1 )
	X? ( >=x11-libs/wxGTK-2.4.2-r2 )
	lzo? ( dev-libs/lzo )
	dev-libs/expat
	app-arch/bzip2
	sys-libs/zlib"

pkg_setup(){
	if use X; then
		has_version '>=x11-libs/wxGTK-2.6.0' && WX_GTK_VER="2.6"
		if use unicode; then
			need-wxwidgets unicode
		elif use gtk2; then
			need-wxwidgets gtk2
		else
			need-wxwidgets gtk
		fi
	fi
}

src_compile() {
	sed -i "s:wx-config:$WX_CONFIG:g" configure
	econf `use_enable X gui` || die "configure died"

	emake || die "make failed"
}

src_install() {
	einstall || die "install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	dohtml doc/mkvmerge-gui.html doc/mkvmerge-gui.hh* doc/images/*
}
