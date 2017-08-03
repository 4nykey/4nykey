# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="47da246"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools ltprune python-single-r1

DESCRIPTION="A Guile 2.0 interface to Sorts Mill Core Library"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="+atomic-ops nls python"

RDEPEND="
	dev-libs/sortsmill-core
	dev-libs/libunicodenames
	dev-scheme/guile:12
	atomic-ops? ( dev-libs/libatomic_ops )
	python? (
		${PYTHON_DEPS}
		dev-libs/gmp:0
	)
"
DEPEND="
	${RDEPEND}
	dev-util/sortsmill-tig
	virtual/yacc
	sys-apps/help2man
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with atomic-ops)
		$(use_with python)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	prune_libtool_files --all
}
