# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
FONT_TYPES_EXCLUDE="otf"
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN}-hinted"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	EGIT_BRANCH="everything-in-source"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="9856860"
	SRC_URI="
		binary? (
			https://github.com/google/${PN}/releases/download/v${PV}/${MY_PN}.zip
			-> ${MY_PN}-${PV%_p*}.zip
		)
		!binary? (
			mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-f363b48"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
RESTRICT="primaryuri"

DESCRIPTION="Google's signature family of fonts"
HOMEPAGE="https://github.com/google/roboto"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="clean-as-you-go +binary interpolate"
REQUIRED_USE="binary? ( !font_types_otf )"

DEPEND="
	binary? (
		app-arch/unzip
	)
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}/${MY_PN}"
	else
		python-any-r1_pkg_setup
		FONT_S=( master_{o,t}tf )
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	rm -f "${S}"/src/v2/Roboto.designspace
}

src_compile() {
	use binary && return
	emake \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		$(usex interpolate '' 'INTERPOLATE=') \
		$(usex clean-as-you-go '' 'RM=true') \
		-f ${MY_MK}/Makefile.ds
}
