# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PV="${PV//./-}-license-adobe"
MY_CJK="${PN}-cjk-1.004"
CHECKREQS_DISK_BUILD="$(usex cjk 1130 50)M"
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
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit check-reqs font

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"
EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts.git"

LICENSE="Apache-2.0 cjk? ( OFL-1.1 )"
SLOT="0"
IUSE="cjk"

DEPEND=""
RDEPEND="!media-fonts/notofonts"

FONT_SUFFIX="ttf"
DOCS="*.md"
if use cjk; then
	FONT_SUFFIX="${FONT_SUFFIX} otf"
	DOCS="
		${DOCS}
		${WORKDIR}/${MY_CJK}/HISTORY
		${WORKDIR}/${MY_CJK}/NEWS
		${WORKDIR}/${MY_CJK}/README*
	"
fi

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		use cjk && \
		EGIT_CHECKOUT_DIR="${MY_CJK}" \
		EGIT_REPO_URI="https://github.com/googlei18n/noto-cjk.git" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	mv hinted/Noto*.ttf "${S}"/
	use cjk && mv "${WORKDIR}"/${MY_CJK}/NotoSans[JKST]*.otf "${S}"/
}
