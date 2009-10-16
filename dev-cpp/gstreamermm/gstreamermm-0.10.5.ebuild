# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

DESCRIPTION="GStreamer API C++ bindings"
HOMEPAGE="http://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples"

RDEPEND="
	>=dev-cpp/glibmm-2.16.0
	dev-cpp/libxmlpp:2.6
	>=media-libs/gst-plugins-base-0.10.24
	examples? ( dev-cpp/gtkmm:2.4 )
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable doc docs) \
		$(use_enable examples) \
		|| die
}
