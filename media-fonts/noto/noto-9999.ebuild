# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PV="${PV//./-}-license-adobe"
MY_CJK="${PN}-cjk-1.004"
MY_SRC="${PN}-source-2f579b0"
CHECKREQS_DISK_BUILD="30"
use cjk && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+930))"
use fontmake && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+960))"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_BUILD}M"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}-fonts/tar.gz/v${MY_PV}
		-> ${P}.tar.gz
		cjk? (
		mirror://githubcl/googlei18n/${MY_CJK%-*}/tar.gz/v${MY_CJK##*-}
		-> ${MY_CJK}.tar.gz
		)
		fontmake? (
		mirror://githubcl/googlei18n/${MY_SRC%-*}/tar.gz/${MY_SRC##*-}
		-> ${MY_SRC}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit check-reqs multiprocessing font

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="fontmake cjk"

DEPEND="
	fontmake? ( dev-python/fontmake )
"
RDEPEND="!media-fonts/notofonts"

FONT_SUFFIX="ttf"
DOCS="*.md"
if use cjk || use fontmake; then
	FONT_SUFFIX="${FONT_SUFFIX} otf"
fi

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		use cjk && \
		EGIT_CHECKOUT_DIR="${MY_CJK}" \
		EGIT_REPO_URI="https://github.com/googlei18n/${MY_CJK%-*}.git" \
			git-r3_src_unpack
		use fontmake && \
		EGIT_CHECKOUT_DIR="${MY_SRC}" \
		EGIT_REPO_URI="https://github.com/googlei18n/${MY_SRC%-*}.git" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	mv unhinted/Noto*.ttf "${S}"/
	mv hinted/Noto*.ttf "${S}"/
	use cjk && mv "${WORKDIR}"/${MY_CJK}/NotoSans[JKST]*.otf "${S}"/
}

src_compile() {
	use fontmake || return

	cd "${WORKDIR}"/${MY_SRC}
	multijob_init
	local g
	for g in src/*.glyphs src/*/*.plist; do
		multijob_child_init source ./build.sh build_one "${g}" || die
	done
	multijob_finish
	mv master_[ot]tf/*.[ot]tf "${S}"/
}
