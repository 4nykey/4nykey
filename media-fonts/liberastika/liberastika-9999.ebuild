# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ -z ${PV%%*9999} ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
else
	S="${WORKDIR}"
	inherit font
	IUSE="fontforge"
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/lib-ka/${PN}-ttf-${PV}.tar.xz
	)
	fontforge? (
		mirror://sourceforge/lib-ka/${PN}-src-${PV}.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi



DESCRIPTION="Liberastika fonts are fork of Liberation Sans"
HOMEPAGE="http://lib-ka.sourceforge.net"

LICENSE="GPL-2-with-font-exception"
SLOT="0"

DEPEND="
	media-gfx/fontforge[python]
	media-gfx/xgridfit
	dev-util/font-helpers
"
RDEPEND="
	!media-fonts/liberastika-ttf
"
FONT_SUFFIX="ttf pfb"

if [[ -n ${PV%%*9999} ]] && use !fontforge; then
	DEPEND=""
	FONT_SUFFIX="ttf"
fi

src_prepare() {
	if [[ -n ${PV%%*9999} ]] && use !fontforge; then return 0; fi
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}
