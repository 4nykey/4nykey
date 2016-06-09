# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/heuristica/heuristica-0.2.1.ebuild,v 1.1 2010/03/06 20:02:59 spatz Exp $

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	SRC_URI="mirror://gcarchive/evristika/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/evristika/trunk"
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
	KEYWORDS="~amd64 ~x86"
fi
inherit latex-package font

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="http://heuristica.sourceforge.net"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="fontforge latex"
RESTRICT="primaryuri"

DEPEND="
	fontforge? (
		<media-gfx/fontforge-20150430[python]
		dev-texlive/texlive-fontutils
		sys-apps/coreutils
		media-gfx/xgridfit
		dev-util/font-helpers
	)
"

FONT_SUFFIX="afm otf pfb ttf"
DOCS="FontLog.txt"

src_prepare() {
	default
	use fontforge && \
		cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_compile() {
	default
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
