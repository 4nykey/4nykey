# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	DEPEND="
		media-gfx/fontforge[python]
		media-gfx/xgridfit
	"
else
	S="${WORKDIR}"
	inherit font
	IUSE="fontforge"
	MY_PN="lib-ka"
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/${MY_PN}/${PN}-ttf-${PV}.tar.xz
	)
	fontforge? (
		mirror://sourceforge/${MY_PN}/${PN}-src-${PV}.tar.xz
		http://font-helpers.googlecode.com/files/font-helpers-src-1.2.1.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	DEPEND="
		fontforge? (
			media-gfx/fontforge[python]
			media-gfx/xgridfit
		)
	"
fi



DESCRIPTION="Liberastika fonts are fork of Liberation Sans"
HOMEPAGE="http://lib-ka.sf.net"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	!media-fonts/liberastika-ttf
"
FONT_SUFFIX="ttf pfb"

pkg_setup() {
	if [[ ${PV} != *9999* ]] && use !fontforge; then
		FONT_SUFFIX="ttf"
	fi
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
		ESVN_PROJECT="font-helpers" \
			subversion_fetch "http://font-helpers.googlecode.com/svn/trunk"
	fi
	default
}

