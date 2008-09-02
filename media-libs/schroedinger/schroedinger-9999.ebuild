# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/schroedinger/schroedinger-0.9.0.ebuild,v 1.1 2008/01/26 08:35:04 drac Exp $

inherit git autotools

DESCRIPTION="C-based libraries and GStreamer plugins for the Dirac video codec"
HOMEPAGE="http://schrodinger.sourceforge.net"
EGIT_REPO_URI="git://diracvideo.org/git/schroedinger.git"
AT_M4DIR="m4"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="|| ( MPL-1.1 LGPL-2.1 GPL-2 MIT )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gstreamer test"

RDEPEND="
	>=dev-libs/liboil-0.3.12
	gstreamer? ( >=media-libs/gst-plugins-base-0.10 )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	test? ( >=dev-libs/check-0.9.2 )
	dev-util/gtk-doc-am
"

src_compile() {
	econf \
		--disable-gtk-doc \
		$(use_enable gstreamer) \
		|| die "econf failed"
	emake || die "emake failed."
}

src_install() {
	einstall || die "emake install failed."
	dodoc ChangeLog NEWS TODO
}
