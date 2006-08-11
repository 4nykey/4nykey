# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=42755"
SRC_URI="http://cimi.netsons.org/media/download_gallery/Murrine.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8"

S="${WORKDIR}/Murrine"

src_compile() {
	econf --enable-animation || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	elog "For themes utilizing this engine check"
	elog "http://www.gnome-look.org/content/search.php?name=murrin&type=100&search=1"
}
