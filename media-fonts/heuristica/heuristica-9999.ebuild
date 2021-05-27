# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
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
inherit python-single-r1 latex-package font-r1

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="https://sourceforge.net/projects/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
RESTRICT="primaryuri"
IUSE="+binary latex"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
			media-gfx/xgridfit[${PYTHON_SINGLE_USEDEP}]
		')
		dev-texlive/texlive-fontutils
		sys-apps/coreutils
		dev-util/font-helpers
		latex? ( app-text/lcdf-typetools )
	)
"

pkg_setup() {
	use binary || python-single-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || \
		cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
	[[ -z ${PV%%*9999} ]] && eapply "${FILESDIR}"/${PN}-r65.diff

}

src_compile() {
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

pkg_postinst() {
	font-r1_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font-r1_pkg_postrm
	use latex && latex-package_pkg_postrm
}
