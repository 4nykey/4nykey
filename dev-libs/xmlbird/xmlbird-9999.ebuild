# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1 vala toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/johanmattssonm/${PN}.git"
	inherit git-r3
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="58c28cb"
	fi
	SRC_URI="
		mirror://githubcl/johanmattssonm/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="XML parser for Vala and C programs"
HOMEPAGE="https://birdfont.org/xmlbird.php"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	"${PYTHON}" ./configure \
		--prefix "${EPREFIX}/usr" \
		--cc "$(tc-getCC)" \
		--valac "${VALAC}" \
		--cflags "${CFLAGS}" \
		--ldflags "${LDFLAGS}" \
		--libdir "/$(get_libdir)" \
		|| die
}

src_compile() {
	"${PYTHON}" ./build.py || die
}

src_install() {
	"${PYTHON}" ./install.py \
		--dest "${D}" \
		|| die
	einstalldocs
}
