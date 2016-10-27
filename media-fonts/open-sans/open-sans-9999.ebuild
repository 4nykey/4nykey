# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/google/fonts"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	FONT_S=( apache/opensans{,condensed,hebrew,hebrewcondensed} )
else
	_base="90abd17"
	_base="mirror://githubraw/google/fonts/${_base}/apache/opensans/OpenSans-"
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
inherit font-r1

DESCRIPTION="A clean and modern sans-serif typeface for web, print and mobile"
HOMEPAGE="http://opensans.com/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

FONT_SUFFIX="ttf"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
	else
		cp "${DISTDIR}"/*.ttf "${FONT_S}"/
	fi
}
