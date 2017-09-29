# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_EAUTORECONF="yes"
inherit gnome2
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/adapta-project/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="e33c6d2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adapta-project/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An adaptive Gtk+ theme based on Material Design Guidelines"
HOMEPAGE="https://github.com/adapta-project/${PN}"

LICENSE="GPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="cinnamon gnome mate openbox +threads xfce"

RDEPEND="
	x11-libs/gdk-pixbuf:2
"
DEPEND="
	${RDEPEND}
	media-gfx/inkscape
	dev-lang/sassc
	threads? ( sys-process/parallel )
"

src_prepare() {
	sed -e '/ADAPTA_OPTION/s:disable:enable:' -i configure.ac
	gnome2_src_prepare
}

src_configure() {
	econf \
		$(use_enable gnome) \
		$(use_enable cinnamon) \
		$(use_enable mate) \
		$(use_enable openbox) \
		$(use_enable threads parallel) \
		$(use_enable xfce) \
		--enable-gtk_next
}
