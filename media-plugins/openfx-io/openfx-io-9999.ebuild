# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MrKepzie/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="1e07155"
	[[ -n ${PV%%*_p*} ]] && MY_PV="Natron-${PV}"
	MY_OFX='openfx-d1b81a0'
	MY_SUP='openfx-supportext-77ea0d2'
	MY_SEQ='SequenceParsing-84b816f'
	MY_TIN='tinydir-60f0905'
	SRC_URI="
		mirror://githubcl/MrKepzie/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/devernay/${MY_OFX%-*}/tar.gz/${MY_OFX##*-} -> ${MY_OFX}.tar.gz
		mirror://githubcl/devernay/${MY_SUP%-*}/tar.gz/${MY_SUP##*-} -> ${MY_SUP}.tar.gz
		mirror://githubcl/MrKepzie/${MY_SEQ%-*}/tar.gz/${MY_SEQ##*-} -> ${MY_SEQ}.tar.gz
		mirror://githubcl/MrKepzie/${MY_TIN%-*}/tar.gz/${MY_TIN##*-} -> ${MY_TIN}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A set of Readers/Writers plugins written using the OpenFX standard"
HOMEPAGE="https://github.com/MrKepzie/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/openexr
	media-libs/openimageio[colorio,ffmpeg,opengl,raw]
	media-libs/libpng:0
	dev-libs/seexpr:0
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" -i Makefile.master
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_OFX}/* "${S}"/openfx
		mv "${WORKDIR}"/${MY_SUP}/* "${S}"/SupportExt
		mv "${WORKDIR}"/${MY_SEQ}/* "${S}"/IOSupport/SequenceParsing
		mv "${WORKDIR}"/${MY_TIN}/* "${S}"/IOSupport/SequenceParsing/tinydir
	fi
}

src_compile() {
	local myemakeargs=(
		CXX=$(tc-getCXX)
		CXXFLAGS_ADD="${CXXFLAGS}"
		LDFLAGS_ADD="${LDFLAGS}"
		V=1
	)
	emake "${myemakeargs[@]}"
}
