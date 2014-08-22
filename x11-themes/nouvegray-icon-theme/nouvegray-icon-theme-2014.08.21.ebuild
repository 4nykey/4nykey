# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker gnome2-utils

DESCRIPTION="A light gray icon set"
HOMEPAGE="
	http://tsujan.deviantart.com/art/nouveGnomeGray-300365158
	http://tsujan.deviantart.com/art/nouveKDEGray-359475268
"
SRC_URI="
gnome? ( http://fc07.deviantart.net/fs71/f/${PV%%.*}/233/f/3/nouvegnomegray_by_tsujan-d4ytv8m.7z -> nouvegnomegray-${PV}.7z )
kde? ( http://fc07.deviantart.net/fs71/f/${PV%%.*}/233/c/6/nouvekdegray_by_tsujan-d5y0sw4.7z -> nouvekdegray-${PV}.7z )
smplayer? ( http://fc07.deviantart.net/fs71/f/${PV%%.*}/233/c/6/nouvekdegray_by_tsujan-d5y0sw4.7z -> nouvekdegray-${PV}.7z )
"
S="${WORKDIR}"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="branding gnome kde smplayer"
REQUIRED_USE="|| ( gnome kde smplayer )"

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND="
	gnome? ( x11-themes/gnome-icon-theme )
	smplayer? ( media-video/smplayer )
"

src_prepare() {
	mkdir -p share/{icons,smplayer/themes}
	if [[ -d "${S}"/nouveGnomeGray ]]; then
		mv "${S}"/{nouveGnomeGray,share/icons}
		cd "${S}"/share/icons/nouveGnomeGray
		mv AUTHORS "${S}"/AUTHORS.nouveGnomeGray
		use branding && \
			find -name distributor-logo.png | while read d; do
				ln -sf gentoo-logo.png "${d}"
			done
	fi
	if [[ -d "${S}"/nouveKDEGray ]]; then
		mv "${S}"/{nouveKDEGray,share/icons}
		cd "${S}"/share/icons/nouveKDEGray
		if use smplayer; then
			rm -f nouveKDEGray-SMPlayer/README*
			mv nouveKDEGray-SMPlayer "${S}"/share/smplayer/themes/nouveKDEGray
		else
			rm -r nouveKDEGray-SMPlayer
			rm -r "${S}"/share/smplayer
		fi
		mv AUTHORS "${S}"/AUTHORS.nouveKDEGray
	fi
	find "${S}"/share/icons -mindepth 2 -! -type d -! -name '*.*' | xargs rm
}

src_install() {
	insinto /usr
	doins -r share/
	dodoc AUTHORS*
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
