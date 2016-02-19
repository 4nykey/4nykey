# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_PN="M2Crypto"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/${PN}/${PN}.git"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="M2Crypto: A Python crypto and SSL toolkit"
HOMEPAGE="https://github.com/martinpaljak/M2Crypto https://pypi.python.org/pypi/M2Crypto"

LICENSE="BSD"
SLOT="0"
IUSE="libressl"

RDEPEND="
	!libressl? ( >=dev-libs/openssl-0.9.8:0= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.28:0
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# Tests access network, and fail randomly. Bug #431458.
RESTRICT=test

python_test() {
	esetup.py test
}
