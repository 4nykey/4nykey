# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools
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
IUSE="apidocs"

RDEPEND=""
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake all $(usex apidocs dox '')
}
