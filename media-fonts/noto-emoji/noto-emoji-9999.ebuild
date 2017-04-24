# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="color-emoji-binary"
	MY_PV="v${PV//./-}-${MY_PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="09e5d14"
	SRC_URI="mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Noto Emoji fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary zopfli"

DEPEND="
!binary? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/nototools[${PYTHON_USEDEP}]
	')
	media-gfx/pngquant
	media-gfx/imagemagick
	zopfli? ( app-arch/zopfli )
	!zopfli? ( media-gfx/optipng )
	x11-libs/cairo
)
"

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
	use binary && return
	sed \
		-e 's:CFLAGS =:CFLAGS +=:' \
		-i Makefile
}

src_compile() {
	use binary && return
	addpredict /dev/dri
	tc-export CC
	emake \
		PNGQUANT=/usr/bin/pngquant \
		$(usex zopfli '' 'MISSING_ZOPFLI=1')
	rm -f *.tmpl.ttf
}
