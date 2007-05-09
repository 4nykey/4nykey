# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="A console XMSS2 client using libgnt"
HOMEPAGE="http://www.site.uottawa.ca/~schow031/gntxmms2/"
EGIT_REPO_URI="git://git.xmms.se/xmms2/gntxmms2.git"
EGIT_PATCHES="${PN}-*.diff"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	net-im/pidgin
	media-sound/xmms2
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

pkg_setup() {
	if ! built_with_use net-im/pidgin console; then
		eerror "This package requires libgnt, emerge net-im/pidgin with USE=console."
		die "need libgnt"
	fi
}

src_install() {
	dobin gx
}
