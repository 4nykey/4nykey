# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	MY_PV="1.0.3"
	SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.tar.xz"
else
	IUSE="fontforge"
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
	)
	fontforge? (
		mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Istok is a sans serif typeface"
HOMEPAGE="http://istok.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	media-gfx/fontforge[python]
	>media-gfx/xgridfit-2.3
	dev-python/fonttools
	dev-util/font-helpers
"
RDEPEND=""
FONT_SUFFIX="ttf pfb"
if [[ -n ${PV%%*9999} ]] && use !fontforge; then
	FONT_SUFFIX="ttf"
	DEPEND=""
fi
DOCS="AUTHORS ChangeLog README TODO"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		# some files missing in svn repo
		unpack ${A}
		mv "${WORKDIR}/${PN}-${MY_PV}" "${S}"
		subversion_src_unpack
	else
		default
	fi
}

src_prepare() {
	if [[ -n ${PV%%*9999} ]] && use !fontforge; then return 0; fi
	sed \
		-e 's:\<rm\>:& -f:' \
		-e '/_acc\.xgf:/ s:_\.sfd:.gen.ttf:' \
		-i Makefile
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_install() {
	rm -f *.gen.ttf
	font_src_install
}
