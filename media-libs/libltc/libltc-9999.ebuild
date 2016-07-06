# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/x42/libltc.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/x42/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Linear/Logitudinal Time Code (LTC) Library"
HOMEPAGE="https://github.com/x42/libltc"

LICENSE="LGPL-3"
SLOT="0"
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
