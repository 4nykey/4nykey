# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	REQUIRED_USE="!binary"
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
else
	S="${WORKDIR}"
	SRC_URI="
	binary? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-otf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-pfb-${PV}.tar.xz
		latex? (
			mirror://sourceforge/${PN}/${PN}-tex-${PV}.tar.xz
		)
	)
	!binary? (
		mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.xz
	)
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit latex-package font

DESCRIPTION="Khartiya is extended Bitstream Charter font"
HOMEPAGE="http://code.google.com/p/khartiya"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary latex"

DEPEND="
	!binary? (
		media-gfx/fontforge[python]
		dev-texlive/texlive-fontutils
		sys-apps/coreutils
		media-gfx/xgridfit
		dev-util/font-helpers
	)
"
RESTRICT="primaryuri"
FONT_SUFFIX="afm otf pfb ttf"
DOCS=( FontLog.txt )

src_prepare() {
	default
	use binary || cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_compile() {
	# fontforge fails with EMFILE otherwise
	use binary || ulimit -n 4096
	default
}

src_install() {
	if use latex; then
		if use binary; then
			insinto "${TEXMF}"
			doins -r "${WORKDIR}"/{dvips,fonts,tex}
		else
			emake TEXPREFIX="${ED}/${TEXMF}" tex-support
			rm -rf "${ED}"/${TEXMF}/doc
		fi
		echo "Map ${PN}.map" > "${T}"/${PN}.cfg
		insinto /etc/texmf/updmap.d
		doins "${T}"/${PN}.cfg
	fi
	rm -f *.gen.ttf
	font_src_install
}
