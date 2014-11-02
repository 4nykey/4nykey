# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

UR="14.04"
MY_P="${PN%-*}_${PV}_ubuntu_${UR}_x86_64"
DESCRIPTION="AceStream engine"
HOMEPAGE="http://acestream.org"

SRC_URI="http://dl.acestream.org/ubuntu/${UR%.*}/${MY_P}.tar.gz"
RESTRICT="primaryuri strip"

LICENSE="acestream-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
S="${WORKDIR}/${MY_P}"

DEPEND="
"
RDEPEND="
	${PYTHON_DEPS}
	dev-python/apsw[${PYTHON_USEDEP}]
	dev-python/m2crypto[${PYTHON_USEDEP}]
	dev-libs/libappindicator:2[python]
	dev-python/bitarray[${PYTHON_USEDEP}]
	dev-python/blist[${PYTHON_USEDEP}]
	dev-python/miniupnpc[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/geoip-python[${PYTHON_USEDEP}]
"

src_install() {
	local _instdir="/opt/acestream" _binary="${PN/-}"
	insinto "${_instdir}"
	doins -r .
	fperms 0755 "${_instdir}/${_binary}"
	find ${D} -type f -name '*.egg' -delete
	make_wrapper ${_binary} \
		"${_instdir}/${_binary} --lib-path ${_instdir}" \
		"${_instdir}" "${_instdir}/lib"
}
