# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2
MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/erikdubois/${PN}.git"
	SRC_URI=""
else
	MY_PV="6035cfc"
	[[ -n ${PV%%*_p*} ]] && MY_PV="$(ver_rs 2 -)"
	SRC_URI="
		mirror://githubcl/erikdubois/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
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
	mv surfn-icons/${MY_PN}/{CREDITS,changelog} .
	find -mindepth 2 \
		-regex '.*\(CREDITS\|LICENSE\|.*\.txt\|.*\.cache.*\|.* .*\)' -delete
	find -L -type l -delete
	default
}

src_configure() { :; }

src_install() {
	insinto /usr/share/icons
	doins -r surfn-icons/.
	einstalldocs
}
