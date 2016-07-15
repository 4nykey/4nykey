# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="Cloak-3.20"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/killhellokitty/${MY_P}.git"
else
	inherit vcs-snapshot
	MY_PV="180ef76"
	SRC_URI="
		mirror://githubcl/killhellokitty/${MY_P}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A black transparent theme for Gtk-3"
HOMEPAGE="https://github.com/killhellokitty/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
IUSE="cinnamon firefox gdm openbox xfce"

DEPEND=""
RDEPEND="
	cinnamon? ( gnome-extra/cinnamon )
	xfce? ( xfce-base/xfwm4 )
	${DEPEND}
"
S="${WORKDIR}/${P}/${MY_P}"

src_install() {
	insinto /usr/share/themes/${MY_P}
	doins -r \
		gnome-shell \
		gtk-* \
		metacity-1 \
		$(usev cinnamon) \
		$(usex openbox openbox-3 '') \
		$(usex xfce xfwm4 '') \
		index.theme

	insinto /usr/share/${PN}
	use firefox && doins -r Firefox
	use gdm && doins "${S}-GDM"/gnome-shell-theme.gresource
	dodoc README
}
