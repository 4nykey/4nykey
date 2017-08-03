# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="4739568"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools ltprune python-single-r1

DESCRIPTION="A Python module for Sorts Mill Tools"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="cython nls"

RDEPEND="
	${PYTHON_DEPS}
	media-gfx/sortsmill-tools
"
DEPEND="
	${RDEPEND}
	dev-util/sortsmill-tig
	virtual/yacc
	cython? ( dev-python/cython )
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-install-as-fontforge
	)
	ac_cv_path_CYTHON=$(usev cython) \
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	prune_libtool_files --modules
}
