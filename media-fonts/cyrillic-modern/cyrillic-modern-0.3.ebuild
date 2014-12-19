# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base
FONT_SUFFIX="afm pfb"
DOCS="doc/fonts/nm/FontLog.txt"
if [[ ${PV} == *9999* ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	DEPEND="
		media-gfx/fontforge[python]
		dev-python/fonttools
		dev-libs/kpathsea
		dev-texlive/texlive-basic
	"
	FONT_SUFFIX="${FONT_SUFFIX} ttc"
	DOCS="FontLog.txt"
else
	S="${WORKDIR}"
	inherit font
	SRC_URI="
		mirror://sourceforge/${PN}/nm-${PV}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Cyrillic version of Computer Modern fonts"
HOMEPAGE="http://code.google.com/p/cyrillic-modern"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
		ESVN_PROJECT="font-helpers" \
			subversion_fetch "http://font-helpers.googlecode.com/svn/trunk"
		ESVN_PROJECT="afdko/trunk/FDK/Tools/SharedData/FDKScripts" \
			subversion_fetch "https://github.com/adobe-type-tools/afdko/trunk/FDK/Tools/SharedData/FDKScripts"
	fi
	default
}

src_prepare() {
	if [[ ${PV} != *9999* ]]; then
		mv fonts/{afm,type1}/public/nm/*.* .
	fi
}

src_compile() {
	base_src_compile all otf
	find "${S}" -type l -delete
}
