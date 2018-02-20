# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/erikdubois/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	MY_PV="6035cfc"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/erikdubois/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A colourful icon theme for linux desktops"
HOMEPAGE="https://github.com/erikdubois/${PN}"

LICENSE="CC-BY-NC-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
DOCS=( README.md CREDITS changelog )

src_prepare() {
	mv ${PN^}/{CREDITS,changelog} .
	find -mindepth 2 \
		-regex '.*\(CREDITS\|LICENSE\|.*\.txt\|.*\.cache.*\|.* .*\)' -delete
	find -L -type l -delete
	default
}

src_configure() { default; }

src_install() {
	insinto /usr/share/icons
	doins -r ${PN^}*
	einstalldocs
}
