# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/varlesh/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="f13d5c4"
	SRC_URI="
		mirror://githubcl/varlesh/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Papirus GTK Icon Theme"
HOMEPAGE="https://github.com/varlesh/papirus-gtk-icon-theme"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="libreoffice smplayer"

DEPEND=""
RDEPEND="
	libreoffice? ( app-office/libreoffice )
	smplayer? ( media-video/smplayer )
"

src_prepare() {
	mv Papirus-GTK/AUTHORS .
	find -mindepth 2 -type f -regex '.*\(AUTHORS\|LICENSE\)' -delete
	find -L -type l -delete
}

src_install() {
	insinto /usr/share/icons
	doins -r Papirus*-GTK
	if use smplayer; then
		insinto /usr/share/smplayer/themes/
		doins -r extra/smplayer-themes/Papirus*
	fi
	if use libreoffice; then
		insinto /usr/$(get_libdir)/libreoffice/share/config
		doins extra/libreoffice-icons/*.zip
	fi
	dodoc AUTHORS README.md
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
