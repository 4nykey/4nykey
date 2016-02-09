# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/erikdubois/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="df641a2"
	SRC_URI="
		mirror://githubcl/erikdubois/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Yltra Flat icon theme"
HOMEPAGE="https://github.com/erikdubois/yltra-flat-icon-theme"

LICENSE="CC-BY-NC-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	local d
	for d in Yltra\ Flat*; do mv "${d}" "${d// /}"; done
	insinto /usr/share/icons
	doins -r Yltra*
	dodoc README.md YltraFlat/{CREDITS,log.txt}
	find "${ED}"/usr/share/icons -mindepth 2 -type f \
		-regex '.*\(CREDITS\|.*\.txt\|.*\.cache\)' -delete
	find -L "${ED}"/usr/share/icons -type l -delete
	find "${ED}"/usr/share/icons -name '* *' -delete
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
