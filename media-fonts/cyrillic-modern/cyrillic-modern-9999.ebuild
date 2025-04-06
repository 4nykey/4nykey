# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..13} )
MY_FONT_TYPES=( +otf ttc )
inherit python-single-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk"
	REQUIRED_USE="!binary"
	MY_P="${P}"
else
	MY_P="${PN}/trunk"
	MY_PV="${PV%_p*}"
	SRC_URI="
	binary? (
		https://downloads.sourceforge.net/cyrillic-modern/nm-otf+ttc-${MY_PV}.tar.xz
		latex? ( https://downloads.sourceforge.net/cyrillic-modern/nm-${MY_PV}.tar.xz )
	)
	!binary? (
		mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip
	)
	"
	KEYWORDS="~amd64"
fi
inherit latex-package font-r1

DESCRIPTION="Cyrillic version of Computer Modern fonts"
HOMEPAGE="https://code.google.com/p/cyrillic-modern"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary latex"
RESTRICT="primaryuri"
BDEPEND="
	!binary? (
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
			dev-python/fonttools[${PYTHON_USEDEP}]
			font_types_ttc? ( dev-util/afdko[${PYTHON_USEDEP}] )
		')
		dev-util/font-helpers
		latex? (
			dev-libs/kpathsea
			dev-texlive/texlive-basic
		)
		app-arch/unzip
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}/nm-${MY_PV}"
	else
		S="${WORKDIR}/${MY_P}"
		python-single-r1_pkg_setup
	fi
	font-r1_pkg_setup
	use latex && DOCS+=" USAGE"
}

src_prepare() {
	default
	use binary && return
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
	use binary && return
	emake otf \
		$(usex latex 'all nm.map' '') \
		$(usex font_types_ttc '' 'OTCFONTS=') \
		OTF2OTC="otf2otc"
}

src_install() {
	if use latex; then
		if use binary; then
			insinto "${TEXMF}"
			doins -r "${WORKDIR}"/{dvips,fonts,tex}
			dodoc "${WORKDIR}"/doc/fonts/nm/USAGE
		else
			emake install \
				OTCFONTS= TEXPREFIX="${ED}/${TEXMF}" DESTDIR="${ED}"
			rm -rf "${ED}"/${TEXMF}/doc
			dodoc USAGE
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
