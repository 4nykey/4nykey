# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_IN_SOURCE_BUILD=0
DISTUTILS_USE_SETUPTOOLS=no
inherit autotools distutils-r1
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
	>=dev-python/babelfont-0.0.2[${PYTHON_USEDEP}]
	>=dev-python/cffsubr-0.2.7[${PYTHON_USEDEP}]
	>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/font-v-1.0.2[${PYTHON_USEDEP}]
	>=dev-util/fontmake-2.2[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.13[ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-python/pcpp-1.21[${PYTHON_USEDEP}]
	>=dev-util/psautohint-2.1[${PYTHON_USEDEP}]
	>=dev-python/pygit2-1.2.1[${PYTHON_USEDEP}]
	dev-python/sfdLib[${PYTHON_USEDEP}]
	>=dev-python/skia-pathops-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/ufo2ft-2.15[cffsubr,${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.8[${PYTHON_USEDEP}]
	>=dev-util/gftools-0.4.1
	dev-util/sfdnormalize
	media-gfx/ttfautohint
	media-libs/woff2
	app-shells/zsh
"
DEPEND="
	${RDEPEND}
"
PATCHES=( "${FILESDIR}"/${PN}_rules.diff )

python_prepare_all() {
	sed -e '/sfnt2woff-zopfli/d' -i configure.ac
	eautoreconf
	touch setup.py
	distutils-r1_python_prepare_all
}

python_configure() {
	econf
	echo "${PV%_p*}" > .version
}

python_compile() {
	emake
}

python_install() {
	emake \
		DESTDIR="${D%/}/_${EPYTHON}" \
		bindir=$(python_get_scriptdir) \
		install
	distutils-r1_python_install
}
