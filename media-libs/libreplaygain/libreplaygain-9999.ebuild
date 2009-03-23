# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools subversion

DESCRIPTION="Replaygain library"
HOMEPAGE="http://www.replaygain.org http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libreplaygain"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	einstall || die
}
