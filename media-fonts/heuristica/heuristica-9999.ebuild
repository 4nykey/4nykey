# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES=( pfb otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI="mirror://gcarchive/evristika/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/evristika/trunk"
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

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="https://sourceforge.net/projects/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
RESTRICT="primaryuri"
IUSE="+binary latex"

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

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || \
		cp "${EPREFIX}"/usr/share/font-helpers/*.{ff,py} "${S}"/
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

pkg_postinst() {
	font-r1_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font-r1_pkg_postrm
	use latex && latex-package_pkg_postrm
}
