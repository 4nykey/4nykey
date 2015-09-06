# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/google/fonts"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
else
	_base="90abd17b4f97671435798b6147b698aa9087612f"
	_base="${EGIT_REPO_URI}/raw/${_base}/apache/opensans/OpenSans-"
	SRC_URI="
		${_base}Bold.ttf
		${_base}BoldItalic.ttf
		${_base}ExtraBold.ttf
		${_base}ExtraBoldItalic.ttf
		${_base}Italic.ttf
		${_base}Light.ttf
		${_base}LightItalic.ttf
		${_base}Regular.ttf
		${_base}Semibold.ttf
		${_base}SemiboldItalic.ttf
	"
	_base="${_base/sans/sanscondensed}Cond"
	SRC_URI="
		${SRC_URI}
		${_base}Bold.ttf
		${_base}Light.ttf
		${_base}LightItalic.ttf
	"
	RESTRICT="primaryuri"
	S="${WORKDIR}"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Open Sans is a clean and modern sans-serif typeface"
HOMEPAGE="http://opensans.com/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

FONT_SUFFIX="ttf"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		mv "${S}"/apache/${PN}*/*.ttf "${S}"/
	else
		cp "${DISTDIR}"/*.ttf "${S}"/
	fi
}
