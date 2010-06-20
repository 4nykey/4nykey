# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gaupol/gaupol-0.15.1.ebuild,v 1.2 2010/05/25 21:46:28 pacho Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils fdo-mime gnome2-utils versionator

DESCRIPTION="Gaupol is a subtitle editor for text-based subtitles."
HOMEPAGE="http://home.gna.org/gaupol"
SRC_URI="http://download.gna.org/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell apidocs"

RDEPEND="
	>=dev-python/pygtk-2.10
	dev-python/chardet
	spell? (
		>=dev-python/pyenchant-1.1.3
		app-text/iso-codes
	)
"
DEPEND="
	${RDEPEND}
	apidocs? ( dev-python/sphinx )
	sys-devel/gettext
	dev-util/intltool
"

DISTUTILS_GLOBAL_OPTIONS=("$(use_with spell iso-codes)")
DOCS="AUTHORS ChangeLog CREDITS NEWS TODO README*"

src_compile() {
	addpredict /root/.gconf
	addpredict /root/.gconfd
	distutils_src_compile $(use apidocs && echo doc)
}

src_install() {
	distutils_src_install
	use apidocs && dohtml -r doc/sphinx/_build/html/
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	elog "Previewing support needs MPlayer or VLC."

	if use spell; then
		elog "Additionally, spell-checking requires a dictionary, any of"
		elog "Aspell/Pspell, Ispell, MySpell, Uspell, Hspell or AppleSpell."
	fi
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
