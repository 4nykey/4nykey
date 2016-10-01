# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Changaco/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A setuptools_scm plugin that adds support for git archives"
HOMEPAGE="https://github.com/Changaco/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
