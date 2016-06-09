# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	REQUIRED_USE="fontforge"
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
else
	S="${WORKDIR}"
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
	KEYWORDS="~amd64 ~x86"
fi
inherit latex-package font

DESCRIPTION="Liberastika fonts are fork of Liberation Sans"
HOMEPAGE="http://lib-ka.sourceforge.net"

LICENSE="GPL-2-with-font-exception"
SLOT="0"
IUSE="fontforge latex"

DEPEND="
	fontforge? (
		<media-gfx/fontforge-20150430[python]
		media-gfx/xgridfit
		dev-util/font-helpers
	)
"
RDEPEND="
	!media-fonts/liberastika-ttf
"
RESTRICT="primaryuri"

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
	FONT_SUFFIX="$(usex fontforge 'pfb' '') ttf"
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
