# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

DESCRIPTION="Open Sans is a clean and modern sans-serif typeface"
HOMEPAGE="http://opensans.com/"
EHG_PROJECT="googlefontdirectory"
EHG_REPO_URI="https://code.google.com/p/${EHG_PROJECT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	net-misc/wget
"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	# hg repo is 3GB+ in size, fetch with wget instead
	local _norm _cond _uris
	_norm="http://${EHG_PROJECT}.googlecode.com/hg/apache/${PN}/OpenSans-"
	_cond="${_norm/sans/sanscondensed}Cond"
	_uris=(
		${_norm}Bold.ttf
		${_norm}BoldItalic.ttf
		${_norm}ExtraBold.ttf
		${_norm}ExtraBoldItalic.ttf
		${_norm}Italic.ttf
		${_norm}Light.ttf
		${_norm}LightItalic.ttf
		${_norm}Regular.ttf
		${_norm}Semibold.ttf
		${_norm}SemiboldItalic.ttf
		${_cond}Bold.ttf
		${_cond}Light.ttf
		${_cond}LightItalic.ttf
	)
	ebegin "fetching fonts"
	wget -o ${T}/fetch.log -P "${S}" "${_uris[@]}"
	eend $? || die "fetching failed, check ${T}/fetch.log"
}
