# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit fdo-mime gnome2-utils

DESCRIPTION="Elegant Gnome Pack"
HOMEPAGE="http://gnome-look.org/content/show.php/Elegant+Gnome+Pack?content=127826"
SRC_URI="http://ompldr.org/vNjRwNg/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	>=x11-themes/gtk-engines-murrine-0.98.0
	media-fonts/droid
	gnome-extra/zenity
"

src_compile() {
	emake gentoo || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
