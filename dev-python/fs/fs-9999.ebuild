# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 optfeature
MY_PN="pyfilesystem2"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PyFilesystem/${MY_PN}.git"
else
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="ea2051c"
	SRC_URI="
		mirror://githubcl/PyFilesystem/${MY_PN}/tar.gz/${MY_PV}
		-> ${MY_PN}-${PV}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi

DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="https://www.pyfilesystem.org"

LICENSE="MIT"
SLOT="0"
IUSE="doc test"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/pyftpdlib[${PYTHON_USEDEP},test]
	)
"
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "S3 support" dev-python/boto
	optfeature "SFTP support" dev-python/paramiko
	optfeature "Browser support" dev-python/wxpython
}
