# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	REQUIRED_USE="fontforge"
	MY_PV="1.0.3"
	SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.tar.xz"
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
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Istok is a sans serif typeface"
HOMEPAGE="http://istok.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"
IUSE="fontforge latex"

DEPEND="
	fontforge? (
		media-gfx/fontforge[python]
		media-gfx/xgridfit
		<=dev-python/fonttools-2.4
		dev-util/font-helpers
	)
"
RDEPEND=""
FONT_SUFFIX="$(usex fontforge 'pfb' '') ttf"
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
	if use fontforge; then
		sed \
			-e 's:\<rm\>:& -f:' \
			-e '/_acc\.xgf:/ s:_\.sfd:.gen.ttf:' \
			-i Makefile
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
