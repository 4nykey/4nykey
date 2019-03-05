# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )
DISTUTILS_SINGLE_IMPL=1
PLOCALES="
af ar ast bg ca cs cy da de el en_CA en_GB en eo es et fa fi fo fr_CA fr fy gl
he hi hr hu id is it ja kn ko lt mr nb nds ne nl oc pa pl pt_BR pt ro ru sco sk
sl sr sv ta te tr uk vi zh_CN zh_TW
"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/metabrainz/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="release-${PV/_rc/dev}"
	SRC_URI="
		mirror://githubcl/metabrainz/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
inherit eutils distutils-r1 l10n xdg

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+acoustid nls"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/PyQt5[${PYTHON_USEDEP},gui]
	>=media-libs/mutagen-1.37[${PYTHON_USEDEP}]
	acoustid? ( >=media-libs/chromaprint-1.0[tools] )
	dev-python/python-discid[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

DOCS=( {AUTHORS,HACKING,NEWS}.txt {CONTRIBUTING,README}.md )

src_prepare() {
	myloc() {
		rm -f po/{.,attributes,countries}/${1}.po
	}
	l10n_for_each_disabled_locale_do myloc
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

python_test() {
	esetup.py test
}
