# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit python-any-r1 font-r1
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
	')
	>=dev-python/nanoemoji-0.14.3
	virtual/imagemagick-tools[png]
	app-arch/zopfli
	x11-libs/cairo
	>=app-i18n/unicode-emoji-15
)
"
PATCHES=( "${FILESDIR}"/pyimp.diff )

pkg_setup() {
	if use binary; then
		FONT_S=( fonts )
	else
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	rm -f fonts/NotoColorEmoji_WindowsCompatible.ttf
	use binary && return
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
	tc-env_build emake \
		PNGQUANT=/usr/bin/pngquant \
		PYTHON="${EPYTHON}" \
		BYPASS_SEQUENCE_CHECK='True' \
		VIRTUAL_ENV=1
	rm -f *.tmpl.ttf
	nanoemoji colrv1/*.toml
	cp build/NotoColorEmoji.ttf Noto-COLRv1.ttf
	cp build/NotoColorEmoji-noflags.ttf Noto-COLRv1-noflags.ttf
}
