# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/heuristica/heuristica-0.2.1.ebuild,v 1.1 2010/03/06 20:02:59 spatz Exp $

EAPI=5

if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://evristika.googlecode.com/svn/trunk"
else
	S="${WORKDIR}"
	IUSE="fontforge"
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-otf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-pfb-${PV}.tar.xz
	)
	fontforge? (
		mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="http://heuristica.sourceforge.net"

LICENSE="OFL-1.1"
SLOT="0"

DEPEND="
	media-gfx/fontforge[python]
	dev-texlive/texlive-fontutils
	sys-apps/coreutils
	media-gfx/xgridfit
	dev-util/font-helpers
"
if [[ -n ${PV%%*9999} ]] && use !fontforge; then
	DEPEND=""
fi

FONT_SUFFIX="afm otf pfb ttf"
DOCS="FontLog.txt"

src_prepare() {
	if [[ -n ${PV%%*9999} ]] && use !fontforge; then return 0; fi
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_install() {
	rm -f *.gen.ttf
	font_src_install
}
