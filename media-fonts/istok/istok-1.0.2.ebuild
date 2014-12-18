# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
else
	S="${WORKDIR}"
	inherit font
	IUSE="fontforge gpl"
	SRC_URI="
	!fontforge? (
		gpl? ( mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz )
		!gpl? ( mirror://sourceforge/${PN}/${PN}-ofl-ttf-${PV}.tar.xz )
	)
	fontforge? (
		mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.xz
		http://font-helpers.googlecode.com/files/font-helpers-src-1.2.1.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Istok is a sans serif typeface"
HOMEPAGE="https://code.google.com/p/istok"

LICENSE="|| ( GPL-3-with-font-exception OFL-1.1 )"
SLOT="0"

DEPEND="
	media-gfx/fontforge[python]
	media-gfx/xgridfit
	dev-python/fonttools
"
RDEPEND=""
FONT_SUFFIX="ttf pfb"
if [[ ${PV} != *9999* ]] && use !fontforge; then
	FONT_SUFFIX="ttf"
	DEPEND=""
fi

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
		ESVN_PROJECT="font-helpers" \
			subversion_fetch "http://font-helpers.googlecode.com/svn/trunk"
	fi
	default
}

src_prepare() {
	sed -e '/_acc\.xgf:/ s:_\.sfd:.gen.ttf:' -i Makefile
}

src_install() {
	rm -f *.gen.ttf
	font_src_install
}
