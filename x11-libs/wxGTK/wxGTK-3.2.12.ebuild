# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WXRELEASE="$(ver_cut 1-2)-gtk3"

DESCRIPTION="GTK version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org/"

LICENSE="wxWinLL-3 GPL-2"
SLOT="${WXRELEASE}/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+X curl doc debug keyring gstreamer libnotify +lzma opengl pch sdl +spell test tiff wayland webkit"
IUSE+=" +legacy"
REQUIRED_USE="legacy"

PDEPEND="
	x11-libs/wxWidgets:$(ver_cut 1-2)=[X?,curl?,doc?,debug?,keyring?,gstreamer?,libnotify?,lzma?,opengl?,pch?,sdl?,spell?,test?,tiff?,wayland?,webkit?]
"
