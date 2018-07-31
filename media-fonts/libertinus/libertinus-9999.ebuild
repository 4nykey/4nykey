# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_SUFFIX=otf
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/khaledhosny/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="983ab6c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/khaledhosny/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/khaledhosny/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			|| (
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			dev-python/sortsmill-ffcompat[${PYTHON_USEDEP}]
			)
		')
	)
"
DOCS="*.linuxlibertine.txt"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	# force rebuild
	touch "${S}"/Makefile
	# strip flag that fontforge doesn't understand
	has_version dev-python/sortsmill-ffcompat || \
		sed -e 's:, "no-mac-names"::' -i "${S}"/tools/build.py
}

src_compile() {
	use binary && return
	emake \
		PY=${EPYTHON} \
		${FONT_SUFFIX}
}
