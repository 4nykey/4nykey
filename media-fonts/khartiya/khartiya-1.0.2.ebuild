# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	SRC_URI=""
	REQUIRED_USE="fontforge"
else
	S="${WORKDIR}"
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-otf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-pfb-${PV}.tar.xz
		latex? (
			mirror://sourceforge/${PN}/${PN}-tex-${PV}.tar.xz
		)
	)
	fontforge? (
		mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Khartiya is extended Bitstream Charter font"
HOMEPAGE="http://code.google.com/p/khartiya"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="fontforge latex"

DEPEND="
	fontforge? (
		media-gfx/fontforge[python]
		dev-texlive/texlive-fontutils
		sys-apps/coreutils
		media-gfx/xgridfit
		dev-util/font-helpers
	)
"

FONT_SUFFIX="afm otf pfb ttf"
DOCS="FontLog.txt"

src_prepare() {
	if use fontforge; then
		cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
	fi
}

src_compile() {
	if use fontforge; then
		default
	fi
}

src_install() {
	if use latex; then
		if use fontforge; then
			emake TEXPREFIX="${ED}/${TEXMF}" tex-support
			rm -rf "${ED}"/${TEXMF}/doc
		else
			insinto "${TEXMF}"
			doins -r "${WORKDIR}"/{dvips,fonts,tex}
		fi
		echo "Map ${PN}.map" > "${T}"/${PN}.cfg
		insinto /etc/texmf/updmap.d
		doins "${T}"/${PN}.cfg
	fi
	rm -f *.gen.ttf
	font_src_install
}
