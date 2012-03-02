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
IUSE="debug static-libs vfs301"

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

src_unpack() {
	git-2_src_unpack
	if use vfs301; then
		EGIT_SOURCEDIR="${S}/vfs301" \
		EGIT_REPO_URI="git://github.com/andree182/vfs301.git" \
			git-2_src_unpack
	fi
}

src_prepare() {
	if use vfs301; then
		mv vfs301/{libfprint/vfs301.c,cli/vfs301_*.*} libfprint/drivers
		epatch vfs301/libfprint/integrate_vfs301.patch
	fi
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-log)
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure
}
