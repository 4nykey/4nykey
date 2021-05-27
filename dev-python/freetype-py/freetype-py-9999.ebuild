# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rougier/${PN}.git"
else
	MY_P="${PN}-${PV/_p/.post}"
	SRC_URI="
		mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Python bindings for the freetype library"
HOMEPAGE="https://github.com/rougier/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	media-libs/freetype:2
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	cd tests
	pytest -v || die
}
