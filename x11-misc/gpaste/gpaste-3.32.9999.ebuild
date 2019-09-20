# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.42"
VALA_MAX_API_VERSION="${VALA_MIN_API_VERSION}"
VALA_USE_DEPEND="vapigen"
inherit vala xdg
MY_GNOME="${PV:2:2}"
MY_GNOME="${PV%%.*}.$((MY_GNOME+MY_GNOME%2))"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Keruspe/GPaste.git"
	EGIT_BRANCH="${PN}-${MY_GNOME}"
	SRC_URI=""
else
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
	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3.24:3
	gnome-base/gnome-control-center:2
	>=x11-libs/gdk-pixbuf-2.38
	sys-apps/dbus
	vala? ( $(vala_depend) )
	gnome-shell? (
		media-libs/clutter
		=x11-wm/mutter-${MY_GNOME}*:0
	)
	introspection? ( >=dev-libs/gobject-introspection-1.58 )
	>=dev-libs/gjs-1.54
"
DEPEND="
	${RDEPEND}
	dev-libs/appstream-glib
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	use vala && vala_src_prepare
	default
}

src_configure() {
	local myconf=(
		$(use_enable vala)
		$(use_enable introspection)
		$(use_enable bash-completion)
		$(use_enable gnome-shell gnome-shell-extension)
		$(use_enable zsh-completion)
	)
	econf "${myconf[@]}"
}
