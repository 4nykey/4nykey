# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="WaveMixer is a multitrack wave editor"
HOMEPAGE="http://wavemixer.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=dev-cpp/gtkmm-2.4.0
	=dev-libs/libsigc++-1.2*
	=media-libs/gstreamer-0.8*
	>=media-libs/taglib-1.1
	>=media-libs/librasc-0.0.1
	>=media-sound/esound-0.2.0
	>=media-sound/jack-audio-connection-kit-0.90.0
	media-sound/sox
	>=dev-libs/libxml2-2.6.11
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
"

src_unpack() {
	unpack ${A}
	cd ${S}
	# check for gtkmm <= 2.8 will fail with 2.8.1
	epatch ${FILESDIR}/gtkmm_cfg_fix.diff
	sed -i "/\<CXXFLAGS\>/d" src/Makefile.am
	intltoolize -f || die
	eautoreconf
}

src_install() {
	einstall || die
	dodoc ChangeLog
	make_desktop_entry waveMixer WaveMixer gnome-audio
}
