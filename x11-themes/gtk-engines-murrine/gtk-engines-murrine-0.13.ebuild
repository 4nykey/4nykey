# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN##*-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=42755"
SRC_URI="http://cimi.netsons.org/media/download_gallery/${MY_PN}/${MY_P}.tar.bz2"
RESTRICT="primaryuri"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-2.8
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	econf \
		--enable-animation \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	elog "For themes utilizing this engine check"
	elog "http://www.gnome-look.org/content/search.php?name=murrin&type=100&search=1"
}
