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
IUSE="debug apidocs examples"

RDEPEND="
	>=dev-cpp/glibmm-2.18.1
	dev-cpp/libxmlpp:2.6
	>=media-libs/gst-plugins-base-0.10.23
	examples? ( dev-cpp/gtkmm:2.4 )
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable apidocs docs) \
		$(use_enable examples)
}
