# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-python.git"
else
	SRC_URI="
		mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python implementation of HSLuv (revision 4)"
HOMEPAGE="http://www.hsluv.org/"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
