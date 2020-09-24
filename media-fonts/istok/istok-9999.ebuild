# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk"
	REQUIRED_USE="!binary"
else
	MY_PV="${PV%_p*}"
	SRC_URI="
	binary? (
		mirror://sourceforge/${PN}/${PN}-ttf-${MY_PV}.tar.xz
		latex? ( mirror://sourceforge/${PN}/${PN}-tex-${MY_PV}.tar.xz )
	)
	!binary? (
		mirror://sourceforge/${PN}/${PN}-src-${MY_PV}.tar.xz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-single-r1 latex-package font-r1

DESCRIPTION="Istok is a sans serif typeface"
HOMEPAGE="https://sourceforge.net/projects/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="+binary latex"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
			media-gfx/xgridfit[${PYTHON_SINGLE_USEDEP}]
		')
		dev-python/fonttools
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
	use binary && return
	sed \
		-e 's:\<rm\>:& -f:' \
		-e '/_acc\.xgf:/ s:_\.sfd:.gen.ttf:' \
		-i Makefile
	cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/

	# missing in svn, taken from 1.0.3 tarball
	[[ -e "${S}"/upr_AEsc.xgf ]] || cp "${FILESDIR}"/upr_AEsc.xgf "${S}"/
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
