# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subtitleeditor/subtitleeditor-0.36.1.ebuild,v 1.2 2010/04/21 18:04:19 fauli Exp $

EAPI="2"

inherit gnome2 versionator

DESCRIPTION="GTK+2 subtitle editing tool."
HOMEPAGE="http://home.gna.org/subtitleeditor/"
SRC_URI="http://download.gna.org/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls opengl"

RDEPEND="
	app-text/iso-codes
	>=dev-cpp/gtkmm-2.14
	>=dev-cpp/glibmm-2.16.3
	>=dev-cpp/libxmlpp-2.20
	>=app-text/enchant-1.4
	>=dev-cpp/gstreamermm-0.10.4
	>=media-libs/gst-plugins-good-0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-pango-0.10
	>=media-plugins/gst-plugins-xvideo-0.10
	opengl? ( >=dev-cpp/gtkglextmm-1.2 )
"
# gst-plugins-pango needed for text overlay
# gst-plugins-xvideo needed for video output

DEPEND="
	${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
"

DOCS="AUTHORS ChangeLog NEWS README TODO"
G2CONF="
	$(use_enable debug)
	$(use_enable nls)
	$(use_enable opengl gl)
"
