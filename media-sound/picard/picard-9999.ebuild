# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
PLOCALES="
af ar ast bn bg ca cs cy da de el en_CA en_GB en eo es et fa fi fo fr_CA fr fy gl
he hi hr hu id is it ja kn ko lt mr nb nds ne nl oc pa pl pt_BR pt ro ru sco sk
sl sr sv ta te tr uk vi zh_CN zh_TW de_CH en_AU es_419 ga ms_MY nl_BE pt_PT sq
zh zh-Hans
"
inherit distutils-r1 plocale xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/metabrainz/${PN}.git"
else
	MY_PV=$(ver_cut 4)
	MY_PV="release-$(ver_cut 0-3)${MY_PV:0:1}$(ver_cut 5)"
	SRC_URI="
		mirror://githubcl/metabrainz/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE="discid +fingerprints nls"

BDEPEND="
	nls? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/fasteners[${PYTHON_USEDEP}]
		dev-python/PyQt5[declarative,gui,network,widgets,${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
		discid? ( dev-python/python-discid[${PYTHON_USEDEP}] )
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/pyjwt[${PYTHON_USEDEP}]
	')
	fingerprints? ( media-libs/chromaprint[tools] )
"
DEPEND="
	${RDEPEND}
"
DOCS=( AUTHORS.txt {CONTRIBUTING,NEWS,README}.md )
distutils_enable_tests pytest

src_prepare() {
	myloc() {
		rm -f po/{.,appstream,attributes,countries}/${1}.po
	}
	plocale_for_each_disabled_locale myloc
	distutils-r1_python_prepare_all
}

python_compile() {
	local build_args=(
		--disable-autoupdate
	)
	if ! use nls; then
		build_args+=( --disable-locales )
	fi
	distutils-r1_python_compile ${build_args[@]}
}

python_install() {
	local install_args=(
		--disable-autoupdate
		--skip-build
	)
	if ! use nls; then
		install_args+=( --disable-locales )
	fi
	distutils-r1_python_install ${install_args[@]}
}
