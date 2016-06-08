# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Papirus customization for Linux distros"
HOMEPAGE="https://github.com/varlesh/papirus-suite"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk kde libreoffice qtcurve sddm smplayer vlc"

DEPEND=""
RDEPEND="
	gtk? (
		x11-themes/papirus-icon-theme-gtk
		x11-themes/papirus-gtk-theme
	)
	libreoffice? ( x11-themes/papirus-libreoffice-theme )
	qtcurve? ( x11-themes/papirus-qtcurve-theme )
	sddm? ( x11-themes/papirus-sddm-theme )
	smplayer? ( x11-themes/papirus-smplayer-theme )
	vlc? ( x11-themes/papirus-vlc-theme )
	kde? (
		x11-themes/papirus-color-scheme
		x11-themes/papirus-konsole-colorscheme
		x11-themes/papirus-look-and-feel
		x11-themes/papirus-plasma-theme
		x11-themes/papirus-wallpapers
	)
	!x11-themes/papirus-gtk-icon-theme
"
