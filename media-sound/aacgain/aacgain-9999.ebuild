# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dgilman/${PN}.git"
else
	MY_PV="0421ca2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	MY_FAA="faad2-3918dee" # 2.10.1
	MY_MP4="mp4v2-339f1da" # 5.0.1
	SRC_URI="
		mirror://githubcl/dgilman/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/knik0/${MY_FAA%-*}/tar.gz/${MY_FAA##*-} -> ${MY_FAA}.tar.gz
		mirror://githubcl/TechSmith/${MY_MP4%-*}/tar.gz/${MY_MP4##*-} -> ${MY_MP4}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Normalize perceived loudness of AAC audio files"
HOMEPAGE="https://github.com/dgilman/${PN}"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

PATCHES=(
	"${FILESDIR}"/mp3gain-1.6.2-CVE-2019-18359-plus.patch
)

src_prepare() {
	cmake_src_prepare
	tc-export CC CXX
	[[ -z ${PV%%*9999} ]] && return
	mv ../${MY_FAA}/* 3rdparty/faad2/
	mv ../${MY_MP4}/* 3rdparty/mp4v2/
	cd 3rdparty/mp4v2
	eapply "${FILESDIR}"/libmp4v2-2.0.0-unsigned-int-cast.patch
}
