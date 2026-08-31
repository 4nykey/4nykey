# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/Fraunhofer-IIS/${PN}.git"
	inherit git-r3
else
	MY_PV="e296913"
	[[ -n ${PV%%*_p*} ]] && MY_PV="r${PV}"
	SRC_URI+="
		mirror://githubcl/Fraunhofer-IIS/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
	RESTRICT="primaryuri"
fi

DESCRIPTION="An ISOBMFF reader and writer library with MPEG-H 3D Audio support"
HOMEPAGE="https://github.com/Fraunhofer-IIS/${PN}"

LICENSE="FraunhoferFDK"
SLOT="0"
DEPEND="
	dev-libs/ilo
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DUSE_PKGCONFIG_DEPS=yes
	)
	cmake_src_configure
}
