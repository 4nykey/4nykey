# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils versionator

MY_P="${PN}-$(delete_version_separator '_')"
DESCRIPTION="Subtitle Editor is a GTK+2 tool to edit subtitles for GNU/Linux"
HOMEPAGE="http://home.gna.org/subtitleeditor"
SRC_URI="http://download.gna.org/subtitleeditor/$(get_version_component_range -2)/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="spell cairo debug ttxt nls iso-codes opengl"

RDEPEND="
	dev-cpp/gtkmm
	dev-cpp/libglademm:2.4
	media-libs/gst-plugins-good
	dev-libs/libpcre[cxx,unicode]
	spell? ( app-text/enchant )
	cairo? ( x11-libs/cairo )
	>=dev-cpp/libxmlpp-2
	iso-codes? ( app-text/iso-codes )
	opengl? ( dev-cpp/gtkglextmm )
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable spell enchant-support) \
		$(use_enable cairo) \
		$(use_enable ttxt) \
		$(use_enable opengl gl) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
