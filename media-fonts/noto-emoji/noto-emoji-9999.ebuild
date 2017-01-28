# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="v${PV//./-}-license-apache"
	MY_PV="2dc2c4b"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Noto Emoji fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="zopfli"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/nototools[${PYTHON_USEDEP}]
	')
	media-gfx/pngquant
	media-gfx/imagemagick
	zopfli? ( app-arch/zopfli )
	!zopfli? ( media-gfx/optipng )
	x11-libs/cairo
"
FONT_S+=( fonts )

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	sed \
		-e 's:CFLAGS =:CFLAGS +=:' \
		-i Makefile
}

src_compile() {
	addpredict /dev/dri
	tc-export CC
	emake \
		PNGQUANT=/usr/bin/pngquant \
		$(usex zopfli '' 'MISSING_ZOPFLI=1')
	rm -f *.tmpl.ttf
}
