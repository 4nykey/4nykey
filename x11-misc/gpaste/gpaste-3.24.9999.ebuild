# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION="0.36"
VALA_USE_DEPEND="vapigen"
inherit versionator vala autotools gnome2
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	SRC_URI=""
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/Keruspe/GPaste/tar.gz/v${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Clipboard management system"
HOMEPAGE="https://github.com/Keruspe/GPaste"

MY_GNOME="$(get_version_component_range 2)"
MY_GNOME="$(get_major_version).$((${MY_GNOME}+${MY_GNOME}%2))"
EGIT_REPO_URI="https://github.com/Keruspe/GPaste.git"
EGIT_BRANCH="${PN}-${MY_GNOME}"

# until gnome-3.24 is ready
VALA_MIN_API_VERSION="0.34"
KEYWORDS=""

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
	eautoreconf
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
