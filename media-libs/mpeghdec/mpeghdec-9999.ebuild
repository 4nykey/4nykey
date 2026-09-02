# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/Fraunhofer-IIS/${PN}.git"
	inherit git-r3
else
	MY_PV="c08b803"
	[[ -n ${PV%%*_p*} ]] && MY_PV="r${PV}"
	MY_ILO="ilo-r2.0.2"
	MY_MMT="mmtisobmff-r1.0.4"
	SRC_URI+="
		mirror://githubcl/Fraunhofer-IIS/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/Fraunhofer-IIS/${MY_ILO%-*}/tar.gz/${MY_ILO#*-} -> ${MY_ILO}.tar.gz
		mirror://githubcl/Fraunhofer-IIS/${MY_MMT%-*}/tar.gz/${MY_MMT#*-} -> ${MY_MMT}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
	RESTRICT="primaryuri"
fi

DESCRIPTION="A C/C++ implementation of the MPEG-H Audio standard"
HOMEPAGE="https://github.com/Fraunhofer-IIS/${PN}"

LICENSE="FraunhoferFDK"
SLOT="0"
IUSE="apidocs tools"
DEPEND="
	tools? (
		dev-libs/ilo
		media-libs/mmtisobmff
	)
"
BDEPEND="
	apidocs? ( app-text/doxygen )
"
PATCHES=( "${FILESDIR}"/install.diff )

src_configure() {
	local mycmakeargs=(
		-Dmpeghdec_BUILD_BINARIES=$(usex tools)
		-Dmpeghdec_BUILD_DOC=$(usex apidocs)
		-DUSE_PKGCONFIG_DEPS=yes
	)
	cmake_src_configure
}
