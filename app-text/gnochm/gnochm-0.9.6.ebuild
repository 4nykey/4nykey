# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

DESCRIPTION="GNOME utility for viewing MS CHM files"
HOMEPAGE="http://gnochm.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnochm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-python/pychm-0.8.2
	=dev-python/pygtk-2*
	=dev-python/gnome-python-2*"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.21"

G2CONF="${G2CONF} --disable-schemas-install"
DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"

pkg_setup() {
	if ! built_with_use '=dev-python/pygtk-2*' gnome ; then
		eerror "PyGTK2 must be compiled with libglade support for ${PN} to run."
		eerror "Please reemerge pygtk with the gnome USE flag set."
		die "no libglade support in pygtk-2"
	fi
	if ! built_with_use '=dev-python/gnome-python-2*' gtkhtml ; then
		eerror "gnome-python must be compiled with libgtkhtml support for ${PN} to run."
		eerror "Please reemerge gnome-python with the gtkhtml USE flag set."
		die "no libgtkhtml support in gnome-python-2"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	gnome2_omf_fix help/C/Makefile.in
}

src_install() {
	gnome2_src_install SHAREDMIME_TOOL="no" locale_mandir=${D}/usr/share/man
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn ""
	ewarn "GnoCHM may not work properly for ordinary users after installation."
	ewarn "A workaround is for each user to run the following command:"
	ewarn ""
	ewarn "  GCONF_CONFIG_SOURCE=xml::/\$HOME/.gconf \\"
	ewarn "  gconftool-2 --makefile-install-rule /etc/gconf/schemas/gnochm.schemas"
	ewarn ""
	ewarn "See the TROUBLESHOOTING section of the README file for details."
	ewarn ""
	ebeep
	epause 5
}

