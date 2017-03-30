# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jenslody/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	MY_PV="723d186"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/jenslody/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="An extension for displaying weather informations in GNOME Shell"
HOMEPAGE="https://github.com/jenslody/gnome-shell-extension-openweather"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	local _v=$(sed -e '/^\(Version\|Release\):/!d; s:[^0-9.]::g' \
		"${S}"/${PN}.spec |tr '\n' '.')
	_v=${_v%..}
	if [[ -z ${PV%%*9999} ]]; then
		_v=${_v}.$(git log -1 --pretty=format:"%h")
	elif [[ -z ${PV%%*_p*} ]]; then
		_v=${_v}.${MY_PV}
	fi
	econf GIT_VERSION=${_v:-${PV}}
}

pkg_postinst() {
	gnome2_pkg_postinst
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_pkg_postrm
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
