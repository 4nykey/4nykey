# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
MY_FONT_TYPES=( pfb otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk"
	REQUIRED_USE="!binary"
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
HOMEPAGE="https://code.google.com/p/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary latex"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			media-gfx/xgridfit[${PYTHON_USEDEP}]
		')
		dev-texlive/texlive-fontutils
		sys-apps/coreutils
		dev-util/font-helpers
		latex? ( app-text/lcdf-typetools )
	)
"
RESTRICT="primaryuri"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
}

src_compile() {
	use binary && return
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
