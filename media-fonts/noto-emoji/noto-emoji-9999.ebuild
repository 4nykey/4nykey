# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
FONT_S=( fonts )
inherit toolchain-funcs python-any-r1 font-r1
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

BDEPEND="
!binary? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		>=dev-python/nototools-0.2.17[${PYTHON_USEDEP}]
		>=dev-python/nanoemoji-0.14.3[${PYTHON_USEDEP}]
	')
	virtual/imagemagick-tools[png]
	app-arch/zopfli
	x11-libs/cairo
	media-libs/harfbuzz
	>=app-i18n/unicode-emoji-16
)
"
PATCHES=( "${FILESDIR}"/pyimp.diff )

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	rm -f fonts/NotoColorEmoji_WindowsCompatible.ttf
	use binary && return
	rm -f fonts/*.ttf
	sed \
		-e 's:^\t@:\t:' \
		-e '/\(C\|LD\)FLAGS =/s:=:+=:' \
		-e 's:\<pkg-config\>:$(PKG_CONFIG):' \
		-e 's: \$(EMOJI_WINDOWS).ttf::' \
		-i Makefile
}

src_compile() {
	use binary && return

	addpredict /proc/self/comm

	# full_rebuild.sh
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

	${EPYTHON} ./colrv1_generate_configs.py || die
	nanoemoji colrv1/*.toml || die
	mv build/NotoColorEmoji.ttf fonts/Noto-COLRv1.ttf
	mv build/NotoColorEmoji-noflags.ttf fonts/Noto-COLRv1-noflags.ttf
	${EPYTHON} ./colrv1_postproc.py || die
}
