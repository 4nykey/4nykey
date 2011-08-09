# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2-utils

DESCRIPTION="AwOken - Awesome Token icon set"
HOMEPAGE="http://gnome-look.org/content/show.php/AwOken+-+Awesome+Token+icon+set?content=126344"
#SRC_URI="http://www.deviantart.com/download/163570862/ -> ${P}.zip"
SRC_URI="http://fc04.deviantart.net/fs71/f/2011/188/2/2/${PN%%-*}_by_alecive-d2pdw32.zip"
S="${WORKDIR}/AwOken-${PV}"
RESTRICT="primaryuri"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	tar xzf AwOken.tar.gz
	tar xzf AwOkenDark.tar.gz
	cd "${S}"
	# broken absolute paths
	ln -sf ../s11-folders/purple.png AwOken/clear/24x24/places/s11-original/folder.png
	ln -sf ../s11-folders/purple.png AwOken/clear/128x128/places/s11-original/folder.png
}

src_install() {
	insinto /usr/share/icons/AwOken
	doins -r AwOken/{index.theme,clear,extra}
	insinto /usr/share/icons/AwOkenDark
	doins -r AwOkenDark/{index.theme,clear,extra}
	dodoc AwOken{,Dark}/{awoken-icon-theme-customization*,.AwOkenrc*}
	insinto /usr/share/doc/${PF}/pdf
	doins AwOken/*.pdf
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
