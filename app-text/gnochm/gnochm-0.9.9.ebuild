# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GNOME utility for viewing MS CHM files"
HOMEPAGE="http://gnochm.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnochm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="
	>=dev-python/pychm-0.8.3
	=dev-python/pygtk-2*
	=dev-python/gnome-python-2*
	dev-perl/XML-Parser
"
DEPEND="
	${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.21
"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"

src_install() {
	gnome2_src_install SHAREDMIME_TOOL="no" locale_mandir=${D}/usr/share/man
}
