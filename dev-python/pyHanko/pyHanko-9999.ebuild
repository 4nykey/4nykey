# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MatthiasValvekens/${PN}.git"
else
	MY_PV="79b64d7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/MatthiasValvekens/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
RESTRICT+=" test"

DESCRIPTION="A Python library to sign and stamp PDF files"
HOMEPAGE="https://pyhanko.readthedocs.io"

LICENSE="MIT"
SLOT="0"
IUSE="opentype pillow pkcs11"

DEPEND="
	dev-python/asn1crypto[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/pyhanko-certvalidator[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	opentype? (
		dev-python/fonttools[${PYTHON_USEDEP}]
		dev-python/uharfbuzz[${PYTHON_USEDEP}]
	)
	pillow? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/python-barcode[${PYTHON_USEDEP}]
	)
	pkcs11? (
		dev-python/python-pkcs11[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
"
distutils_enable_tests pytest
