# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="v${PV//./-}-license-apache"
	MY_PV="2c3079c"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
FONT_SUFFIX="ttf"
inherit font

DESCRIPTION="Noto Emoji fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="zopfli"

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/nototools
	media-gfx/pngquant
	media-gfx/imagemagick
	zopfli? ( app-arch/zopfli )
	!zopfli? ( media-gfx/optipng )
	x11-libs/cairo
"
DOCS="AUTHORS CONTRIBUTORS *.md"

src_prepare() {
	default
	sed \
		-e 's:CFLAGS =:CFLAGS +=:' \
		-i Makefile
	mv "${S}"/fonts/Noto*.${FONT_SUFFIX} "${S}"/
}

src_compile() {
	addpredict /dev/dri
	tc-export CC
	emake \
		PNGQUANT=/usr/bin/pngquant \
		$(usex zopfli '' 'MISSING_ZOPFLI=1')
	rm -f *.tmpl.ttf
}
