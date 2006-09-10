# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Gaupol is a subtitle editor for text-based subtitles."
HOMEPAGE="http://home.gna.org/gaupol/"
SRC_URI="http://download.gna.org/gaupol/${PV/\.0/}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell"
RESTRICT="primaryuri"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8
	dev-python/chardet
	spell? (
		>=dev-python/pyenchant-1.1.3
		app-text/iso-codes )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool"

src_install() {
	distutils_src_install
	insinto /usr/share/pixmaps
	doins data/icons/gaupol.svg
}

pkg_postinst() {
	elog "Please note that an external video player is required for"
	elog "preview. MPlayer or VLC is recommended."
	if use spell; then
		elog "Additionally, spell-checking requires a dictionary, any of"
		elog "Aspell/Pspell, Ispell, MySpell, Uspell, Hspell or AppleSpell."
	fi
}
