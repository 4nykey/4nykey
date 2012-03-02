# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit subversion autotools-utils

DESCRIPTION="sdcv - console version of StarDict program"
HOMEPAGE="http://sdcv.sourceforge.net"
ESVN_REPO_URI="https://sdcv.svn.sourceforge.net/svnroot/sdcv/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="readline nls"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.1
	readline? ( sys-libs/readline )
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_with readline)
	)
	autotools-utils_src_configure
}
