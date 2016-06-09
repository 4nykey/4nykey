# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	REQUIRED_USE="fontforge"
	MY_PV="1.0.3"
	SRC_URI="
		mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip
		mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.tar.xz
	"
	S="${WORKDIR}/${PN}-${MY_PV}"
else
	SRC_URI="
	!fontforge? (
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
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

DESCRIPTION="Istok is a sans serif typeface"
HOMEPAGE="http://istok.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"
IUSE="fontforge latex"

DEPEND="
	fontforge? (
		<media-gfx/fontforge-20150430[python]
		media-gfx/xgridfit
		dev-python/fonttools
		dev-util/font-helpers
	)
"
RDEPEND=""
DOCS=( AUTHORS ChangeLog README TODO )
RESTRICT="primaryuri"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		# some files missing in svn repo
		unpack ${A}
		cp -a "${WORKDIR}"/${PN}/trunk/* "${S}" || die
	else
		default
	fi
}

src_prepare() {
	default
	use fontforge || return
	sed \
		-e 's:\<rm\>:& -f:' \
		-e '/_acc\.xgf:/ s:_\.sfd:.gen.ttf:' \
		-i Makefile
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_compile() {
	default
}

src_install() {
	FONT_SUFFIX="$(usex fontforge 'pfb' '') ttf"
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
