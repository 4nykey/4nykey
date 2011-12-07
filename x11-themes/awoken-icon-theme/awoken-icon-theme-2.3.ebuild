# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2-utils

MY_PN="AwOken"
DESCRIPTION="AwOken - Awesome Token icon set"
HOMEPAGE="http://alecive.deviantart.com/art/AwOken-163570862"
SRC_URI="http://www.deviantart.com/download/163570862/ -> ${P}.zip"
S="${WORKDIR}"
RESTRICT="primaryuri"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	pushd "${DISTDIR}" &>/dev/null
	unpack ${A}
	local t="$(find ${DISTDIR} -type f -name ${MY_PN}*.tar.gz -printf '%P ')"
	popd &>/dev/null
	unpack ${t}
}

src_prepare() {
	# broken absolute paths
	ln -sf ../s11-folders/purple.png ${MY_PN}/clear/24x24/places/s11-original/folder.png
	ln -sf ../s11-folders/purple.png ${MY_PN}/clear/128x128/places/s11-original/folder.png
}

src_install() {
	local d
	find . -mindepth 1 -maxdepth 1 -type d|while read d; do
		insinto /usr/share/icons/${d}
		doins -r ${d}/{index.theme,clear,extra}
	done
	dodoc ${MY_PN}*/{awoken-icon-theme-customization*,.${MY_PN}rc*}
	insinto /usr/share/doc/${PF}/pdf
	doins ${MY_PN}/*.pdf
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
