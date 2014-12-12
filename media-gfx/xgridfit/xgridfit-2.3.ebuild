# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="A high-level language for gridfitting TrueType fonts"
HOMEPAGE="http://xgridfit.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-gfx/fontforge[python]
"
RDEPEND="
	${DEPEND}
"
S="${WORKDIR}/${PN}"

src_compile() { :; }
