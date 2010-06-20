# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gstreamermm/gstreamermm-0.10.7.3.ebuild,v 1.1 2010/06/02 22:43:08 eva Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="GStreamer API C++ bindings"
HOMEPAGE="http://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug apidocs examples verbose-build"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/libxmlpp:2.6
	>=media-libs/gst-plugins-base-0.10.28
	examples? ( dev-cpp/gtkmm:2.4 )
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
"

G2CONF="
	--disable-dependency-tracking
	$(use_enable !verbose-build silent-rules)
	$(use_enable apidocs documentation)
"
DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${PN}*-gcc45.patch
	use examples || sed -i Makefile.in\
		-e 's:\(SUBDIRS = .* \)examples\(.*\):\1\2:'
	gnome2_src_prepare
}

src_test() {
	# explicitly allow parallel make of tests: they are not built in
	# src_compile() and indeed we'd slow down tremendously to run this
	# serially.
	emake check || die "tests failed"
}
