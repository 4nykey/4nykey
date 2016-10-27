# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES="pfb otf ttf"
if [[ -z ${PV%%*9999} ]]; then
	REQUIRED_USE="!binary"
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
else
	S="${WORKDIR}"
	SRC_URI="
	binary? (
		font_types_pfb? ( mirror://sourceforge/${PN}/${PN}-pfb-${PV}.tar.xz )
		font_types_otf? ( mirror://sourceforge/${PN}/${PN}-otf-${PV}.tar.xz )
		font_types_ttf? ( mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz )
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
inherit python-any-r1 latex-package font-r1

DESCRIPTION="Khartiya is extended Bitstream Charter font"
HOMEPAGE="http://code.google.com/p/khartiya"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	+binary
	latex
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			media-gfx/xgridfit[${PYTHON_USEDEP}]
		')
		dev-texlive/texlive-fontutils
		sys-apps/coreutils
		dev-util/font-helpers
	)
"
RESTRICT="primaryuri"
DOCS=( FontLog.txt )

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

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
	font-r1_src_install
}
