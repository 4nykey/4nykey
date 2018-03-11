# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION="0.36"
VALA_USE_DEPEND="vapigen"
GNOME2_EAUTORECONF="yes"
inherit vala gnome2
MY_GNOME="${PV:2:2}"
MY_GNOME="${PV%%.*}.$((MY_GNOME+MY_GNOME%2))"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Keruspe/GPaste.git"
	EGIT_BRANCH="${PN}-${MY_GNOME}"
	SRC_URI=""
else
	inherit vcs-snapshot
	SRC_URI="https://www.imagination-land.org/files/${PN}/${P}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Clipboard management system"
HOMEPAGE="https://github.com/Keruspe/GPaste"

LICENSE="BSD-2"
SLOT="0"
IUSE="bash-completion gnome-shell introspection vala zsh-completion"
REQUIRED_USE="gnome-shell? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.52:2
	x11-libs/gtk+:3
	=gnome-base/gnome-control-center-${MY_GNOME}*:2
	>=x11-libs/gdk-pixbuf-2.26
	sys-apps/dbus
	vala? ( $(vala_depend) )
	gnome-shell? ( media-libs/clutter )
	introspection? ( >=dev-libs/gobject-introspection-1.52 )
	>=dev-libs/gjs-1.48
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	dev-libs/appstream-glib
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local myconf=(
		$(use_enable vala)
		$(use_enable introspection)
		$(use_enable bash-completion)
		$(use_enable gnome-shell gnome-shell-extension)
		$(use_enable zsh-completion)
	)
	gnome2_src_configure "${myconf[@]}"
}
