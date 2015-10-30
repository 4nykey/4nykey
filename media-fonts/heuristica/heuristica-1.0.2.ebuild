# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/heuristica/heuristica-0.2.1.ebuild,v 1.1 2010/03/06 20:02:59 spatz Exp $

EAPI=5

inherit latex-package
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://evristika.googlecode.com/svn/trunk"
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

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="http://heuristica.sourceforge.net"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="fontforge latex"

DEPEND="
	media-gfx/fontforge[python]
	dev-texlive/texlive-fontutils
	sys-apps/coreutils
	media-gfx/xgridfit
	dev-util/font-helpers
"
if use !fontforge; then
	DEPEND=""
fi

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

pkg_postinst() {
	font_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font_pkg_postrm
	use latex && latex-package_pkg_postrm
}
