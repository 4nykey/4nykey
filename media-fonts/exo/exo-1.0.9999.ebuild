# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
SLOT="${PV:0:3}"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${FONT_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="668e8b4"
	SRC_URI="
		mirror://githubcl/NDISCOVER/${FONT_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"
inherit python-any-r1 font-r1

DESCRIPTION="A geometric sans serif font family"
HOMEPAGE="https://github.com/NDISCOVER/${FONT_PN^}"

LICENSE="OFL-1.1"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		media-gfx/fontforge[${PYTHON_USEDEP}]
	')
"

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	unpack ${MY_MK}.tar.gz
}

src_compile() {
	local _s
	for _s in "${S}"/src/${PN^}*.sfd; do
		if [[ -n ${_s#*-OTF.sfd} ]]; then
			fontforge -script ${MY_MK}/ffgen.py "${_s}" otf
		else
			fontforge -script ${MY_MK}/ffgen.py "${_s}" ttf
		fi
	done
}
