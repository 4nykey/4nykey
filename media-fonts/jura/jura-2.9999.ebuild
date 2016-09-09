# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ossobuffo/${PN}.git"
	REQUIRED_USE='!binary'
else
	SRC_URI="
		binary? (
			http://danieljohnson.name/ttf/Jura-Light.ttf
			http://danieljohnson.name/ttf/Jura-Book.ttf
			http://danieljohnson.name/ttf/Jura-Medium.ttf
			http://danieljohnson.name/ttf/Jura-DemiBold.ttf
		)
		!binary? (
			http://danieljohnson.name/sfd/${PN}-sfd-${PV}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit python-any-r1 font

DESCRIPTION="A family of sans-serif fonts in the Eurostile vein"
HOMEPAGE="http://danieljohnson.name/fonts/jura"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""

pkg_setup() {
	FONT_SUFFIX="$(usex binary t o)tf"
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
	else
		if use binary; then
			cp -a "${DISTDIR}"/Jura*.ttf "${FONT_S}"/
		else
			default
		fi
	fi
	cp "${FILESDIR}"/generate_otf.py "${S}"
}

src_compile() {
	use binary && return
	fontforge -quiet -lang=py -script generate_otf.py "${S}"/Jura*.sfd
}
