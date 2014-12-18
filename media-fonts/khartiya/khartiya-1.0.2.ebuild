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
	IUSE="fontforge"
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-otf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-pfb-${PV}.tar.xz
	)
	fontforge? (
		mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.xz
		http://font-helpers.googlecode.com/files/font-helpers-src-1.2.1.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Khartiya is extended Bitstream Charter font"
HOMEPAGE="http://code.google.com/p/khartiya"

LICENSE="OFL-1.1"
SLOT="0"

DEPEND="
	media-gfx/fontforge[python]
	dev-texlive/texlive-fontutils
	sys-apps/coreutils
	media-gfx/xgridfit
"
if [[ ${PV} != *9999* ]] && use !fontforge; then
	DEPEND=""
fi

FONT_SUFFIX="afm otf pfb ttf"
DOCS="FontLog.txt"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
		ESVN_PROJECT="font-helpers" \
			subversion_fetch "http://font-helpers.googlecode.com/svn/trunk"
	fi
	default
}

src_install() {
	rm -f *.gen.ttf
	font_src_install
}
