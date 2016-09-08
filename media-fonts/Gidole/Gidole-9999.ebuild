# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/larsenwork/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="af00170"
	SRC_URI="
		mirror://githubcl/larsenwork/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="Open Source Modern DIN"
HOMEPAGE="http://gidole.github.io"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		media-gfx/fontforge[${PYTHON_USEDEP}]
	')
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="ReadMe.md"

src_compile() {
	fontforge -quiet -lang=py -c \
	'from sys import argv;\
	f=fontforge.open(argv[1]);\
	f.encoding="UnicodeFull";\
	f.selection.all();\
	f.generate(argv[2],flags=("opentype"));\
	f.close()' \
	Source/Gidole-Regular.sfdir Gidole-Regular.otf || die
}
