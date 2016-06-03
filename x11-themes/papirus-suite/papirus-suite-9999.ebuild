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
	MY_PV="d3795f0"
	SRC_URI="
		mirror://githubcl/varlesh/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Papirus Theme"
HOMEPAGE="https://github.com/varlesh/papirus-suite"

LICENSE="
	CC-BY-SA-4.0
	gtk? ( LGPL-2.1 )
	kde? ( GPL-3 )
	libreoffice? ( GPL-3 )
	smplayer? ( GPL-3 )
"
SLOT="0"
IUSE="gtk kde libreoffice smplayer vlc"

DEPEND=""
RDEPEND="
	x11-themes/gtk-engines-murrine
	x11-libs/gdk-pixbuf:2
	libreoffice? ( app-office/libreoffice )
	smplayer? (
		media-video/smplayer
		!>=x11-themes/smplayer-themes-16.5.3
	)
	vlc? ( media-video/vlc[skins] )
	!x11-themes/papirus-gtk-icon-theme
"

src_prepare() {
	mv gtk-icons/Papirus-GTK/AUTHORS .
	find -mindepth 2 -type f -regex '.*\(AUTHORS\|LICENSE\)' -delete
	find -L -type l -delete
}

src_install() {
	insinto /usr/share/icons
	doins -r gtk-icons/Papirus*-GTK
	if use smplayer; then
		insinto /usr/share/smplayer/themes/
		doins -r players-skins/smplayer-themes/Papirus*
	fi
	if use vlc; then
		insinto /usr/share/vlc/skins2
		doins players-skins/vlc-skins/Papirus*
	fi
	if use libreoffice; then
		insinto /usr/$(get_libdir)/libreoffice/share/config
		doins libreoffice-icons/*.zip
	fi
	if use gtk; then
		insinto /usr/share/themes
		doins -r kde-pack/gtk-themes/papirus*
	fi
	if use kde; then
		insinto /usr/share
		doins -r kde-pack/{color-schemes,QtCurve}
		insinto /usr/share/plasma
		doins -r kde-pack/look-and-feel
		insinto /usr/share/plasma/desktoptheme
		doins -r kde-pack/plasma-themes/papirus*
		insinto /usr/share/konsole
		doins kde-pack/konsole-colorschemes/*.colorscheme
	fi
	dodoc AUTHORS README.md
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
