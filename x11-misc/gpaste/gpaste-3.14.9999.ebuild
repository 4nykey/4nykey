# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"
inherit bash-completion-r1 versionator vala gnome2
if [[ ${PV} = *9999* ]]; then
	inherit git-r3 autotools
	SRC_URI=""
else
	SRC_URI="http://www.imagination-land.org/files/${PN}/${P}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Clipboard management system"
HOMEPAGE="https://github.com/Keruspe/GPaste"

GMAJOR="$(get_version_component_range -2)"
EGIT_REPO_URI="https://github.com/Keruspe/GPaste.git"
EGIT_BRANCH="${PN}-${GMAJOR}"

LICENSE="GPL-3"
SLOT="0"
IUSE="applet ayatana bash-completion gnome-shell vala zsh-completion"

RDEPEND="
	>=dev-libs/glib-2.40:2
	=x11-libs/gtk+-${GMAJOR}*:3[introspection]
	=gnome-base/gnome-control-center-${GMAJOR}*:2
	>=x11-libs/gdk-pixbuf-2.26
	sys-apps/dbus
	vala? ( $(vala_depend) )
	ayatana? ( dev-libs/libappindicator:3 )
	gnome-shell? ( media-libs/clutter )
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

G2CONF="
	--disable-silent-rules
	$(use_enable vala)
	$(use_enable applet)
	$(use_enable ayatana unity)
	$(use_enable gnome-shell gnome-shell-extension)
"

src_prepare() {
	use vala && vala_src_prepare
	[[ ${PV} = *9999* ]] && eautoreconf
	gnome2_src_prepare
}

src_install() {
	default
	use bash-completion && dobashcomp data/completions/${PN}
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins data/completions/_${PN}
	fi
}
