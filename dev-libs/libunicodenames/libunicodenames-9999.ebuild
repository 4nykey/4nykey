# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune
if [[ -z ${PV%%*9999} ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/sortsmill/${PN}"
else
	inherit vcs-snapshot
	MY_PV="a1882b0"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${P}"
	SRC_URI="
		https://bitbucket.org/sortsmill/${PN}/get/${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library to retrieve the information from Unicode Consortium namesList"
HOMEPAGE="https://bitbucket.org/sortsmill/${PN}"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
IUSE="static-libs nls"

RDEPEND=""
DEPEND="
	${RDEPEND}
	virtual/yacc
	sys-apps/gawk
	net-misc/wget
	sys-apps/help2man
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	prune_libtool_files
}
