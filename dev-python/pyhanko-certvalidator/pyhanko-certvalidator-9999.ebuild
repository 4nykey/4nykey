# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
MY_PN="${PN#*-}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MatthiasValvekens/${MY_PN}.git"
else
	MY_PV="59495d4"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/MatthiasValvekens/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi

DESCRIPTION="Python library for validating X.509 certificates and paths"
HOMEPAGE="https://github.com/MatthiasValvekens/certvalidator"

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-python/asn1crypto[${PYTHON_USEDEP}]
	dev-python/oscrypto[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/uritools[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"
EPYTEST_DESELECT=(
	tests/test_crl_client.py::test_fetch_crl_aiohttp
	tests/test_crl_client.py::test_fetch_requests
	tests/test_ocsp_client.py::test_fetch_ocsp_aiohttp
	tests/test_ocsp_client.py::test_fetch_ocsp_requests
	tests/test_registry.py::test_basic_certificate_validator_tls_aia
	tests/test_validate.py::test_ed25519
	tests/test_validate.py::test_ed448
)
distutils_enable_tests pytest
