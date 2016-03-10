# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CHECKREQS_DISK_BUILD="30"
use cjk && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+930))"
use emoji && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+35))"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_BUILD}M"
inherit vcs-snapshot check-reqs font
MY_PV="${PV//./-}-license-adobe"
MY_CJK="${PN}-cjk-1.004"
MY_EMJ="${PN}-emoji-${PV}"
SRC_URI="
	mirror://githubcl/googlei18n/${PN}-fonts/tar.gz/v${MY_PV}
	-> ${P}.tar.gz
	cjk? (
	mirror://githubcl/googlei18n/${MY_CJK%-*}/tar.gz/v${MY_CJK##*-}
	-> ${MY_CJK}.tar.gz
	)
	emoji? (
	mirror://githubcl/googlei18n/${MY_EMJ%-*}/tar.gz/v${PV//./-}-license-apache
	-> ${MY_EMJ}.tar.gz
	)
"
RESTRICT="primaryuri"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"

LICENSE="OFL-1.1 emoji? ( Apache-2.0 )"
SLOT="0"
IUSE="cjk emoji"

DEPEND=""
RDEPEND="!media-fonts/notofonts"

FONT_SUFFIX="ttf"
DOCS="*.md"
if use cjk; then
	FONT_SUFFIX="${FONT_SUFFIX} otf"
fi

src_prepare() {
	mv unhinted/Noto*.ttf "${S}"/
	mv hinted/Noto*.ttf "${S}"/
	use cjk && mv "${WORKDIR}"/${MY_CJK}/NotoSans[JKST]*.otf "${S}"/
	use emoji && mv "${WORKDIR}"/${MY_EMJ}/Noto*.ttf "${S}"/
}
