# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2-utils

DESCRIPTION="AwOken - Awesome Token icon set"
HOMEPAGE="http://gnome-look.org/content/show.php/AwOken+-+Awesome+Token+icon+set?content=126344"
#SRC_URI="http://www.deviantart.com/download/163570862/ -> ${P}.zip"
SRC_URI="http://fc09.deviantart.net/fs70/f/2011/020/9/f/awoken___awesome_token___1_5_by_alecive-d2pdw32.zip"
S="${WORKDIR}/AwOken"
RESTRICT="primaryuri"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	tar xjf AwOken.tar.bz2
	cd "${S}"
	# broken absolute paths
	ln -sf ../s11-folders/purple.png clear/128x128/places/s11-original/folder.png
	ln -sf ../s11-folders/purple.png clear/24x24/places/s11-original/folder.png
	ln -sf classy/aluminum/folder-new.png clear/24x24/places/folder-new.png
}

src_install() {
	#insinto /usr/share/icons/AwOken
	#doins -r index.theme clear extra
	dodir /usr/share/icons/AwOken
	cp -rpP index.theme clear extra ${ED}/usr/share/icons/AwOken
	dodoc awoken-icon-theme-customization* .AwOkenrc
	insinto /usr/share/doc/${PF}/pdf
	doins *.pdf
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
