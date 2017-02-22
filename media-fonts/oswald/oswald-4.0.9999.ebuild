# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN^}Font"
FONT_TYPES=( otf +ttf )
PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/m4rc1e/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="9d7f459"
	SRC_URI="
		mirror://githubcl/m4rc1e/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-cf5cbff"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"
RESTRICT="primaryuri"

DESCRIPTION="A reworking of the classic gothic typeface style"
HOMEPAGE="https://github.com/m4rc1e/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		FONT_S=( fonts/{o,t}tf )
	else
		FONT_S=( master_{o,t}tf )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	emake \
		-f ${MY_MK}/Makefile \
		SRCDIR="sources" \
		${FONT_SUFFIX}
}
