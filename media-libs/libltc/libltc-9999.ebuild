# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils git-r3

DESCRIPTION="Linear/Logitudinal Time Code (LTC) Library"
HOMEPAGE="https://github.com/x42/libltc"
EGIT_REPO_URI="https://github.com/x42/libltc.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

pkg_setup() {
	if use doc; then
		MAKEOPTS+=" all dox" 
		HTML_DOCS=(doc/html/)
	fi
}
