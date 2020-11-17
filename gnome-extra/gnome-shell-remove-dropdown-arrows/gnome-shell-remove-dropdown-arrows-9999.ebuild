# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpdeimos/${PN}.git"
	EGIT_BRANCH=master
	SRC_URI=""
else
	inherit vcs-snapshot
	MY_PV="c241d44"
	[[ -n ${PV%%*_p*} ]] && MY_PV="version/${PV}"
	SRC_URI="
		mirror://githubcl/mpdeimos/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An extension that removes the dropdown arrows from GS menus"
HOMEPAGE="https://github.com/mpdeimos/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
"

src_compile() { :; }

src_install() {
	local _u=$(awk -F\" '/uuid": / {print $4}'  metadata.json)
	insinto /usr/share/gnome-shell/extensions/${_u}
	doins -r *.js{,on}
	dodoc README.md
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
