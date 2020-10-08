# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ubuntu/${PN}.git"
	SRC_URI=""
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="87db22d"
	fi
	SRC_URI="
		mirror://githubcl/ubuntu/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Adds AppIndicator support to gnome shell"
HOMEPAGE="https://github.com/ubuntu/${PN}"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	>gnome-base/gnome-shell-3.33
"

src_compile() { :; }

src_install() {
	local _u=$(awk -F'"' '/uuid/ {print $4}' metadata.json)
	insinto /usr/share/gnome-shell/extensions/${_u}
	doins -r interfaces-xml *.js{,on}
	dodoc {AUTHORS,README}.md
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
