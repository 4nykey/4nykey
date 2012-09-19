# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libfprint/libfprint-0.4.0.ebuild,v 1.3 2011/11/14 00:42:44 xmw Exp $

EAPI=4

inherit git-2 autotools-utils

DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/libfprint/"
EGIT_REPO_URI="git://anongit.freedesktop.org/libfprint/libfprint"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

AUTOTOOLS_AUTORECONF="1"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libusb:1
	dev-libs/nss
	x11-libs/gtk+:2
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-log)
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}
