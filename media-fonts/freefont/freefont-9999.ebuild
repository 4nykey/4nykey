# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="svn://svn.sv.gnu.org/${PN}/trunk/${PN}"
else
	MY_PV="${PV#*_p}"
	SRC_URI="
		binary? (
			mirror://gnu/freefont/${PN}-otf-${MY_PV}.tar.gz
		)
		!binary? (
			mirror://gnu/freefont/${PN}-src-${MY_PV}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit python-any-r1 font

DESCRIPTION="A free family of scalable outline unicode fonts"
HOMEPAGE="http://www.gnu.org/software/freefont"

LICENSE="GPL-3"
SLOT="0"
IUSE="+binary"

FONT_SUFFIX="otf"
DOCS=( AUTHORS ChangeLog CREDITS README )

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		DOCS+=( TROUBLESHOOTING USAGE )
	else
		python-any-r1_pkg_setup
		FONT_S="${S}/sfd"
		DOCS+=( notes/{features,maintenance,troubleshooting,usage}.txt )
	fi
	DOCS="${DOCS[@]}"
	font_pkg_setup
}

src_prepare() {
	default
	use binary && return
	python_fix_shebang "${S}"
	sed \
		-e '/\$(TESTFF)/d' \
		-i sfd/Makefile
}

src_compile() {
	use binary && return
	emake otf FF=fontforge IFP=true
}

src_test() {
	use binary && return
	emake tests
}
