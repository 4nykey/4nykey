# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
DISABLE_AUTOFORMATTING=true
PLOCALES="
af ar ast bg ca cs cy da de el en_CA en_GB en eo es et fa fi fo fr_CA fr fy gl
he hi hr hu id is it ja kn ko lt mr nb nds ne nl oc pa pl pt_BR pt ro ru sco sk
sl sr sv ta te tr uk vi zh_CN zh_TW
"
inherit eutils distutils-r1 readme.gentoo l10n
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/musicbrainz/picard.git"
else
	inherit vcs-snapshot
	SRC_URI="
		http://ftp.musicbrainz.org/pub/musicbrainz/picard/${P}.tar.gz
		mirror://githubcl/musicbrainz/${PN}/release-${PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="http://picard.musicbrainz.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+acoustid +cdda nls"

DEPEND="
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
	dev-qt/qtgui:4[accessibility]
	media-libs/mutagen
	acoustid? ( >=media-libs/chromaprint-1.0[tools] )
	cdda? ( dev-python/python-discid )
"
RDEPEND="${DEPEND}"

RESTRICT="test" # doesn't work with ebuilds
DOCS="AUTHORS.txt NEWS.txt"

DOC_CONTENTS="If you are upgrading Picard and it does not start,
try removing Picard's settings:
    rm ~/.config/MusicBrainz/Picard.conf

You should set the environment variable BROWSER to something like
    firefox '%s' &
to let python know which browser to use."

src_prepare() {
	myloc() {
		rm -f po/{.,attributes,countries}/${1}.po
	}
	l10n_for_each_disabled_locale_do myloc
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile $(usex nls "" "--disable-locales")
}

src_install() {
	distutils-r1_src_install --disable-autoupdate --skip-build \
		$(usex nls "" "--disable-locales")

	doicon picard.ico
	domenu picard.desktop
	readme.gentoo_create_doc
}
