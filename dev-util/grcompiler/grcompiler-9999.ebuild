# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/silnrsi/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/silnrsi/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="The SIL Graphite compiler"
HOMEPAGE="https://github.com/silnrsi/${PN}"

LICENSE="|| ( CPL-0.5 LGPL-2.1+ )"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/icu
"
DEPEND="
	${RDEPEND}
	app-text/docbook2X
"

src_prepare() {
	default
	sed \
		-e '/^@ GrcRegressionTest_LDFLAGS/d' \
		-i "${S}"/test/GrcRegressionTest/Makefile.am || die
	sed \
		-e 's:\(pkgdocdir = \).*:\1$(docdir):' \
		-i "${S}"/doc/Makefile.am || die
	eautoreconf
}
