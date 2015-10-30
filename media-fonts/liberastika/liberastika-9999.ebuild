# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	SRC_URI=""
	REQUIRED_USE="fontforge"
else
	S="${WORKDIR}"
	inherit font
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/lib-ka/${PN}-ttf-${PV}.tar.xz
		latex? (
			mirror://sourceforge/lib-ka/${PN}-tex-${PV}.tar.xz
		)
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
IUSE="fontforge latex"

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

pkg_postinst() {
	font_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font_pkg_postrm
	use latex && latex-package_pkg_postrm
}
