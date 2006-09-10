# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/_/-}"
DESCRIPTION="Subtitle Editor is a GTK+2 tool to edit subtitles for GNU/Linux"
HOMEPAGE="http://kitone.free.fr/subtitleeditor/"
SRC_URI="http://kitone.free.fr/subtitleeditor/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="spell cairo debug"

RDEPEND=">=dev-cpp/gtkmm-2.6.0
	>=dev-cpp/libglademm-2.4.0
	>=media-libs/gst-plugins-base-0.10.0
	spell? ( app-text/aspell )
	cairo? ( x11-libs/cairo )
"
DEPEND="${RDEPEND}
"

src_unpack() {
	unpack ${A}
	sed -i 's:\(ACLOCAL_M4 = \).*:\1:' ${S}/Makefile.in
}

src_compile() {
	econf \
		$(use_enable spell aspell) \
		$(use_enable cairo) \
		$(use_enable debug) || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	insinto /usr/share/pixmaps
	doins share/subtitleeditor-icon.png
}
