# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
PYTHON_COMPAT=( python3_{7..9} )
if [[ ${PV} == *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="svn://svn.sv.gnu.org/${PN}/trunk/${PN}"
	REQUIRED_USE="!binary"
else
	MY_PV="${PV#*_p}"
	SRC_URI="
		binary? (
			font_types_otf? ( mirror://gnu/freefont/${PN}-otf-${MY_PV}.tar.gz )
			font_types_ttf? ( mirror://gnu/freefont/${PN}-ttf-${MY_PV}.zip )
		)
		!binary? (
			mirror://gnu/freefont/${PN}-src-${MY_PV}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	BDEPEND="binary? ( font_types_ttf? ( app-arch/unzip ) )"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit python-single-r1 font-r1

DESCRIPTION="A free family of scalable outline unicode fonts"
HOMEPAGE="https://www.gnu.org/software/freefont"

LICENSE="GPL-3"
SLOT="0"
IUSE="+binary"

DOCS="CREDITS"

BDEPEND="
	!binary? (
	$(python_gen_cond_dep '
		media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
	')
	)
"

pkg_setup() {
	if use binary; then
		DOCS+=" TROUBLESHOOTING USAGE"
	else
		python-single-r1_pkg_setup
		FONT_S=( sfd )
		DOCS+=" notes/*.txt"
		PATCHES+=( "${FILESDIR}"/tools.diff )
	fi

	font-r1_pkg_setup
}

src_prepare() {
	default
	python_fix_shebang -q "${S}"/tools/generate
}

src_compile() {
	use binary && return
	emake \
		FFBIN=/usr/bin/fontforge \
		FF=fontforge \
		${FONT_SUFFIX}
}

src_test() {
	use binary && return
	emake \
		FFBIN=/usr/bin/fontforge \
		FF=fontforge \
		tests
}
