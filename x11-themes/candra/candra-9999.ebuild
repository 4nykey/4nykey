# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="Candra-Themes-3.20"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/killhellokitty/${MY_P}.git"
else
	inherit vcs-snapshot
	MY_PV="6d496eb"
	SRC_URI="
		mirror://githubcl/killhellokitty/${MY_P}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Qt-like set of gray-scale themes for Gtk-3"
HOMEPAGE="https://github.com/killhellokitty/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
IUSE="gdm"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/themes
	doins -r Candra-Theme-3.20*

	insinto /usr/share/${PN}
	use gdm && doins Candra-Theme-GDM/gnome-shell-theme.gresource
}
