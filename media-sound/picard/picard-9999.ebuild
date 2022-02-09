# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL=1
PLOCALES="
af ar ast bg ca cs cy da de el en_CA en_GB en eo es et fa fi fo fr_CA fr fy gl
he hi hr hu id is it ja kn ko lt mr nb nds ne nl oc pa pl pt_BR pt ro ru sco sk
sl sr sv ta te tr uk vi zh_CN zh_TW de_CH en_AU es_419 ga ms_MY nl_BE pt_PT sq
zh zh-Hans
"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/metabrainz/${PN}.git"
else
	MY_PV="release-${PV/_rc/dev}"
	MY_PV="${MY_PV/_beta/b}"
	SRC_URI="
		mirror://githubcl/metabrainz/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit eutils distutils-r1 plocale xdg

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+acoustid nls"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/python-discid[${PYTHON_USEDEP}]
		dev-python/fasteners[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		>=media-libs/mutagen-1.37[${PYTHON_USEDEP}]
		>=dev-python/pyjwt-2[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP},gui]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	acoustid? ( >=media-libs/chromaprint-1.0[tools] )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
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
	distutils-r1_python_compile \
		$(usex nls "" "--disable-locales")
}

python_install() {
	distutils-r1_python_install \
		--disable-autoupdate \
		--skip-build \
		$(usex nls "" "--disable-locales")
}
