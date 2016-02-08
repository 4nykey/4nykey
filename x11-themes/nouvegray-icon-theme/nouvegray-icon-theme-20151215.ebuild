# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker gnome2-utils

DESCRIPTION="A light gray icon set"
HOMEPAGE="
	http://tsujan.deviantart.com/art/nouveGnomeGray-300365158
	http://tsujan.deviantart.com/art/nouveKDEGray-359475268
	http://cai79.deviantart.com/art/nouveGnomeGrayExtraByCAI-362285825
"
SRC_URI="
gnome? (
http://orig06.deviantart.net/a542/f/2015/347/6/6/nouvegnomegray_by_tsujan-d4ytv8m.7z
-> nouvegnomegray-${PV}.7z
)
kde? (
http://orig06.deviantart.net/c2b4/f/2015/303/5/4/nouvekdegray_by_tsujan-d5y0sw4.7z
-> nouvekdegray-${PV}.7z
)
smplayer? (
http://orig06.deviantart.net/c2b4/f/2015/303/5/4/nouvekdegray_by_tsujan-d5y0sw4.7z
-> nouvekdegray-${PV}.7z
)
extras? (
http://orig10.deviantart.net/ef86/f/2014/140/c/4/nouvegnomegrayextrabycai_by_cai79-d5zp1j5.7z
)
"
S="${WORKDIR}"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="branding extras gnome kde smplayer"
REQUIRED_USE="|| ( gnome kde smplayer )"

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND="
	gnome? ( x11-themes/gnome-icon-theme )
	smplayer? ( media-video/smplayer )
"

src_prepare() {
	[[ -d "${S}"/nouveGnomeGray ]] || return
	local d
	use branding && \
		find "${S}"/nouveGnomeGray -name distributor-logo.png | \
			while read d; do ln -sf gentoo-logo.png "${d}"
		done
}

src_install() {
	insinto /usr/share/icons
	if [[ -d "${S}"/nouveGnomeGray ]]; then
		doins -r nouveGnomeGray
		dodoc "${S}"/nouveGnomeGray/{README,AUTHORS}
	fi
	if [[ -d "${S}"/nouveKDEGray ]]; then
		doins -r nouveKDEGray
		newdoc "${S}"/nouveKDEGray/AUTHORS AUTHORS.nouveKDEGray
	fi
	if use smplayer; then
		insinto /usr/share/smplayer/themes/nouveKDEGray-SMPlayer
		doins nouveKDEGray/nouveKDEGray-SMPlayer/*.rcc
	fi
	find "${ED}"/usr/share/icons -mindepth 1 -type f -! -name '*.*' -delete
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
