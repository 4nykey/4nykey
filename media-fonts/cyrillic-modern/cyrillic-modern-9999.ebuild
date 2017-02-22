# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES=( +otf ttc )
inherit python-any-r1
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
	DEPEND="
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			dev-python/fonttools[${PYTHON_USEDEP}]
			font_types_ttc? ( dev-util/afdko[${PYTHON_USEDEP}] )
		')
		dev-util/font-helpers
		dev-libs/kpathsea
		dev-texlive/texlive-basic
	"
else
	SRC_URI="
		mirror://sourceforge/cyrillic-modern/nm-otf+ttc-${PV}.tar.xz
		latex? ( mirror://sourceforge/cyrillic-modern/nm-${PV}.tar.xz )
	"
	S="${WORKDIR}/nm-${PV}"
	KEYWORDS="~amd64 ~x86"
fi
inherit latex-package font-r1

DESCRIPTION="Cyrillic version of Computer Modern fonts"
HOMEPAGE="http://code.google.com/p/cyrillic-modern"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="latex"
RESTRICT="primaryuri"

pkg_setup() {
	use latex && DOCS+=" USAGE"
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && return
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
	if use font_types_ttc; then
		sed -e \
			's%\(nm.map:\) all%cleanotf:\n\t-rm -f $(OTFFILES_COLLECTIONS)\n\1%' \
			-i Makefile
	else
		sed \
			-e 's:OTFFILES_COLLECTIONS=:OTFFILES_SINGLE+=:' \
			-i Makefile
	fi
}

src_compile() {
	[[ -n ${PV%%*9999} ]] && return
	# fontforge fails with EMFILE otherwise
	ulimit -n 4096
	emake otf \
		$(usex latex 'all nm.map' '') \
		$(usex font_types_ttc '' 'OTCFONTS=') \
		OTF2OTC="otf2otc"
}

src_install() {
	if use latex; then
		if [[ -z ${PV%%*9999} ]]; then
			emake install \
				OTCFONTS= TEXPREFIX="${ED}/${TEXMF}" DESTDIR="${ED}"
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
	if [[ -z ${PV%%*9999} ]] && use font_types_ttc; then
		emake cleanotf
	fi
	font-r1_src_install
}

pkg_postinst() {
	font-r1_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font-r1_pkg_postrm
	use latex && latex-package_pkg_postrm
}
