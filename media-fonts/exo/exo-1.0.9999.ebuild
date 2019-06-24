# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )
SLOT="${PV:0:3}"
FONT_PN="${PN}-${SLOT}"
MY_FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${FONT_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="e1dedf7"
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
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		FONT_S=( fonts )
	else
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	local _s
	for _s in "${S}"/sources/sfd/${PN^}*.sfd; do
		if [[ -n ${_s#*-OTF.sfd} ]]; then
			fontforge -script ${MY_MK}/ffgen.py "${_s}" otf
		else
			fontforge -script ${MY_MK}/ffgen.py "${_s}" ttf
		fi
	done
}
