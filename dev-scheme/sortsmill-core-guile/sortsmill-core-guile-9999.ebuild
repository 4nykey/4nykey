# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="a7a4ee8"
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools python-single-r1

DESCRIPTION="A Guile 2.0 interface to Sorts Mill Core Library"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="+atomic-ops python"

DEPEND="
	dev-libs/sortsmill-core
	dev-libs/libunicodenames
	dev-scheme/guile:12
	atomic-ops? ( dev-libs/libatomic_ops )
	python? (
		${PYTHON_DEPS}
		dev-libs/gmp:0
	)
"
RDEPEND="${DEPEND}"

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
		$(use_with python python 2.7)
	)
	econf "${myeconfargs[@]}"
}
