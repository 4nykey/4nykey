# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_P="${PN}-$(delete_version_separator '_')"
DESCRIPTION="Subtitle Editor is a GTK+2 tool to edit subtitles for GNU/Linux"
HOMEPAGE="http://kitone.free.fr/subtitleeditor/"
SRC_URI="http://kitone.free.fr/subtitleeditor/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="spell cairo debug xml nls iso-codes"

RDEPEND="
	>=dev-cpp/gtkmm-2.6.0
	>=dev-cpp/libglademm-2.4.0
	>=media-libs/gst-plugins-good-0.10.0
	dev-libs/libpcre
	spell? ( app-text/enchant )
	cairo? ( x11-libs/cairo )
	xml? ( >=dev-cpp/libxmlpp-2.10 )
	iso-codes? ( app-text/iso-codes )
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable spell enchant-support) \
		$(use_enable cairo) \
		|| die
	emake || die
#		$(use_enable xml ttxt) \
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	insinto /usr/share/pixmaps
	doins share/subtitleeditor-icon.png
}
