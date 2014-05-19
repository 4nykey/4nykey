# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/picard/picard-1.2-r1.ebuild,v 1.1 2013/11/03 09:56:29 yngwin Exp $

EAPI=5
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.6 3.*"
PLOCALES="
af ar ast bg ca cs cy da de el en_CA en_GB en eo es et fa fi fo fr_CA fr fy gl
he hi hu id is it ja kn ko lt mr nb nds ne nl oc pl pt_BR pt ro ru sco sk sl sr
sv ta te tr uk vi zh_CN
"
inherit eutils distutils l10n git-r3

DESCRIPTION="An improved rewrite/port of the Picard Tagger using Qt"
HOMEPAGE="http://musicbrainz.org/doc/PicardQt"
EGIT_REPO_URI="git://github.com/musicbrainz/picard.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+acoustid +cdda nls"

DEPEND="
	dev-python/PyQt4[X]
	media-libs/mutagen
"
RDEPEND="
	${DEPEND}
	acoustid? ( media-libs/chromaprint[tools] )
	cdda? ( dev-python/python-discid )
"

# doesn't work with ebuilds
RESTRICT="test"

DOCS="AUTHORS.txt NEWS.txt"

myloc() {
	rm -f po/{.,attributes,countries}/${1}.po
}

src_prepare() {
	l10n_for_each_disabled_locale_do myloc
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile $(use nls || echo "--disable-locales")
}

src_install() {
	distutils_src_install --disable-autoupdate --skip-build \
		$(use nls || echo "--disable-locales")

	doicon picard.ico
	domenu picard.desktop
}

pkg_postinst() {
	distutils_pkg_postinst
	echo
	ewarn "If you are upgrading Picard and it does not start"
	ewarn "try removing Picard's settings:"
	ewarn "	rm ~/.config/MusicBrainz/Picard.conf"
	elog
	elog "You should set the environment variable BROWSER to something like"
	elog "\"firefox '%s' &\" to let python know which browser to use."
}
