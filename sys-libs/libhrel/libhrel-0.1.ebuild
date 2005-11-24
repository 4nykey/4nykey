# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="libhrel"
HOMEPAGE="http://bmpx.berlios.de/"
SRC_URI=
ESVN_REPO_URI="svn://svn.berlios.de/bmpx/hackground/relational"
ESVN_BOOTSTRAP="WANT_AUTOMAKE=1.7 ./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=dev-libs/glib-2*"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	sys-devel/autoconf"

DOCS="AUTHORS NEWS README"

src_install() {
	einstall || die
}
