# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
FONT_S=( fonts )
MY_FONT_VARIANTS=( +cbdt colrv1 )
inherit toolchain-funcs python-single-r1 font-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}"
else
	MY_PV="934a570"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_P="${PN}-${MY_PV#v}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${MY_P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Noto Emoji fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"
REQUIRED_USE="
	|| ( ${MY_FONT_VARIANTS[@]/#+/} )
"

BDEPEND="
!binary? (
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/nototools-0.2.17[${PYTHON_USEDEP}]
	')
	font_variants_colrv1? (
		$(python_gen_cond_dep '
			>=dev-python/nanoemoji-0.14.3[${PYTHON_USEDEP}]
		')
	)
	font_variants_cbdt? (
		virtual/imagemagick-tools[png]
		app-arch/zopfli
		x11-libs/cairo
		media-libs/harfbuzz
	)
	>=app-i18n/unicode-emoji-16
)
"

pkg_setup() {
	use binary || python-single-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	rm \
		fonts/NotoColorEmoji_WindowsCompatible.ttf \
		fonts/*emojicompat.ttf \
		-f
	use binary && return
	eapply "${FILESDIR}"/pyimp.diff
	sed \
		-e 's:^\t@:\t:' \
		-e '/\(C\|LD\)FLAGS =/s:=:+=:' \
		-e 's:\<pkg-config\>:$(PKG_CONFIG):' \
		-e 's: \$(EMOJI_WINDOWS).ttf::' \
		-i Makefile
}

src_compile() {
	use binary && return

	# full_rebuild.sh

	if use font_variants_cbdt; then
		tc-env_build emake \
			PNGQUANT=/usr/bin/pngquant \
			PYTHON="${EPYTHON}" \
			BYPASS_SEQUENCE_CHECK='True' \
			VIRTUAL_ENV=1
		mv NotoColorEmoji.ttf fonts
		${EPYTHON} ./drop_flags.py fonts/NotoColorEmoji.ttf || die
		hb-subset \
			--unicodes-file=flags-only-unicodes.txt \
			--output-file=fonts/NotoColorEmoji-flagsonly.ttf \
			fonts/NotoColorEmoji.ttf || die
		${EPYTHON} ./update_flag_name.py || die
	fi

	if use font_variants_colrv1; then
		addpredict /proc/self/comm
		${EPYTHON} ./colrv1_generate_configs.py || die
		nanoemoji colrv1/*.toml || die
		mv build/NotoColorEmoji.ttf fonts/Noto-COLRv1.ttf
		mv build/NotoColorEmoji-noflags.ttf fonts/Noto-COLRv1-noflags.ttf
		${EPYTHON} ./colrv1_postproc.py || die
	fi
}

src_install() {
	use font_variants_cbdt || rm -f fonts/NotoColorEmoji*.ttf
	use font_variants_colrv1 || rm -f fonts/Noto-COLRv1*.ttf
	font-r1_src_install
}
