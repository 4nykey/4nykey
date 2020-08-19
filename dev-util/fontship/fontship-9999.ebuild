# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit autotools python-single-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/theleagueof/${PN}.git"
else
	MY_PV="64509b2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/theleagueof/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A font development toolkit"
HOMEPAGE="https://github.com/theleagueof/${PN}"

LICENSE="AGPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/babelfont-0.0.2[${PYTHON_USEDEP}]
		>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/pcpp-1.21[${PYTHON_USEDEP}]
		>=dev-python/pygit2-1.2.1[${PYTHON_USEDEP}]
		dev-python/sfdLib[${PYTHON_USEDEP}]
		>=dev-python/ufo2ft-2.15[cffsubr,${PYTHON_USEDEP}]
	')
	>=dev-util/gftools-0.4.1
	>=dev-python/font-v-1.0.2
	>=dev-util/fontmake-2.2
	>=dev-python/fonttools-4.13
	>=dev-util/psautohint-2.1
	dev-util/sfdnormalize
	media-gfx/ttfautohint
	media-libs/woff2
	app-shells/zsh
"
DEPEND="
	${RDEPEND}
"
PATCHES=( "${FILESDIR}"/${PN}_rules.diff )

src_prepare() {
	[[ -n ${PV%%*9999} ]] && echo "${PV%_p*}" > .tarball-version
	./build-aux/git-version-gen .tarball-version > .version
	default
	sed -e '/sfnt2woff-zopfli/d' -i configure.ac
	sed -e '/dist_license_DATA = /d' -i Makefile.am
	eautoreconf
}
