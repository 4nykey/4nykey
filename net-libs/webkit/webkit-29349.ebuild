# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit subversion
#ESVN_REPO_URI="http://svn.webkit.org/repository/webkit/trunk"

inherit autotools

MY_P="WebKit-r${PV}"
DESCRIPTION="WebKit is an open source web browser engine"
HOMEPAGE="http://webkit.org/"
SRC_URI="http://nightly.webkit.org/files/trunk/src/${MY_P}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug sqlite xslt gstreamer svg"

RDEPEND="
	x11-libs/gtk+
	net-misc/curl
	media-libs/jpeg
	media-libs/libpng
	dev-libs/icu
	sqlite? ( >=dev-db/sqlite-3 )
	xslt? ( dev-libs/libxslt )
	gstreamer? (
		media-libs/gst-plugins-base
		gnome-base/gnome-vfs
	)
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	dev-util/gperf
"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${PN}-*.diff
	cp GNUmakefile.am Makefile.am
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable sqlite database) $(use_enable sqlite icon-database) \
		$(use_enable xslt) \
		$(use_enable gstreamer video) \
		$(use_enable svg) \
		|| die

	emake || die "emake failed"
}

src_install() {
	einstall || die "install failed"
}
