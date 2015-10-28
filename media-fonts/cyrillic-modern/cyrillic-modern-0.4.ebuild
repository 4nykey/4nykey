# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://cyrillic-modern.googlecode.com/svn/trunk"
	SRC_URI=""
	DEPEND="
		media-gfx/fontforge[python]
		dev-python/fonttools
		dev-util/font-helpers
		media-gfx/afdko
		dev-libs/kpathsea
		dev-texlive/texlive-basic
	"
else
	S="${WORKDIR}/nm-${PV}"
	SRC_URI="
		mirror://sourceforge/cyrillic-modern/nm-otf+ttc-${PV}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Cyrillic version of Computer Modern fonts"
HOMEPAGE="http://code.google.com/p/cyrillic-modern"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""
FONT_SUFFIX="otf ttc"
DOCS="FontLog.txt"

src_prepare() {
	if [[ -z ${PV%%*9999} ]]; then
		cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
		printf 'cleanotf:\n\t-rm -f $(OTFFILES_COLLECTIONS)\n' >> Makefile
	fi
}

src_compile() {
	if [[ -z ${PV%%*9999} ]]; then
		source "${EPREFIX}"/etc/afdko
		emake otf OTF2OTC="${FDK_EXE}/otf2otc"
		emake cleanotf
	fi
}
