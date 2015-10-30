# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://cyrillic-modern.googlecode.com/svn/trunk"
	SRC_URI=""
	DEPEND="
		media-gfx/fontforge[python]
		dev-python/fonttools
		dev-util/font-helpers
		media-gfx/afdko
		dev-libs/kpathsea
		dev-texlive/texlive-basic
	"
else
	S="${WORKDIR}/nm-${PV}"
	SRC_URI="
		mirror://sourceforge/cyrillic-modern/nm-otf+ttc-${PV}.tar.xz
		latex? ( mirror://sourceforge/cyrillic-modern/nm-${PV}.tar.xz )
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Cyrillic version of Computer Modern fonts"
HOMEPAGE="http://code.google.com/p/cyrillic-modern"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="latex"
FONT_SUFFIX="otf ttc"
DOCS="FontLog.txt"

src_prepare() {
	if [[ -z ${PV%%*9999} ]]; then
		cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
		sed -e \
			's%nm.map: all%cleanotf:\n\t-rm -f $(OTFFILES_COLLECTIONS)\nnm.map:%' \
			-i Makefile
	fi
}

src_compile() {
	if [[ -z ${PV%%*9999} ]]; then
		source "${EPREFIX}"/etc/afdko
		emake otf \
			$(usex latex 'all nm.map' '') \
			OTF2OTC="${FDK_EXE}/otf2otc"
	fi
}

src_install() {
	if use latex; then
		if [[ -z ${PV%%*9999} ]]; then
			einstall OTCFONTS= TEXPREFIX="${ED}/${TEXMF}"
			rm -rf "${ED}"/${TEXMF}/doc
			dodoc USAGE
		else
			insinto "${TEXMF}"
			doins -r "${WORKDIR}"/{dvips,fonts,tex}
			dodoc "${WORKDIR}"/doc/fonts/nm/USAGE
		fi
		echo 'Map nm.map' > "${T}"/${PN}.cfg
		insinto /etc/texmf/updmap.d
		doins "${T}"/${PN}.cfg
	fi
	[[ -z ${PV%%*9999} ]] && emake cleanotf
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
