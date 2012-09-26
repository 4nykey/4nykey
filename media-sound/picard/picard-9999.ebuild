# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/picard/picard-1.0.ebuild,v 1.1 2012/07/12 15:29:33 yngwin Exp $

EAPI=4

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

PLOCALES="
af ar ast bg ca cs cy da de el en_CA en_GB en eo es et fa fi fo fr_CA fr fy gl
he hi hu id is it ja kn ko lt nb nds nl oc pl pt_BR pt ro ru sco sk sl sr sv ta
tr uk zh_CN
"
inherit eutils distutils l10n git-2

DESCRIPTION="An improved rewrite/port of the Picard Tagger using Qt"
HOMEPAGE="http://musicbrainz.org/doc/PicardQt"
EGIT_REPO_URI="git://github.com/musicbrainz/picard.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid cdda ffmpeg nls"

DEPEND="
	dev-python/PyQt4[X]
	media-libs/mutagen
	cdda? ( >=media-libs/libdiscid-0.1.1 )
	ffmpeg? (
		virtual/ffmpeg
		>=media-libs/libofa-0.9.2
	)
"
RDEPEND="
	${DEPEND}
	acoustid? ( media-libs/chromaprint[examples] )
"

# doesn't work with ebuilds
RESTRICT="test"

DOCS="AUTHORS.txt NEWS.txt"

myloc() {
	sed -e "s:[#]*\((u'${2}',\):${1}\1:" -i picard/const.py
}

pkg_setup() {
	if ! use acoustid && ! use ffmpeg; then
		ewarn "The 'acoustid' and 'ffmpeg' USE flag are disabled."
		ewarn "Acoustic fingerprinting and recognition will not be available."
	fi
	if ! use cdda; then
		ewarn "The 'cdda' USE flag is disabled. CD index lookup and"
		ewarn "identification will not be available. You can get audio CD support"
		ewarn "by installing media-libs/libdiscid."
	fi
	python_pkg_setup
}

src_prepare() {
	l10n_for_each_locale_do myloc ''
	l10n_for_each_disabled_locale_do myloc '#'
	distutils_src_prepare
}

src_configure() {
	$(PYTHON -f) setup.py config || die "setup.py config failed"
	if ! use ffmpeg; then
		sed -i -e "s:\(^with-avcodec\ =\ \).*:\1False:" \
			-e "s:\(^with-libofa\ =\ \).*:\1False:" \
			build.cfg || die "sed failed"
	fi
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
