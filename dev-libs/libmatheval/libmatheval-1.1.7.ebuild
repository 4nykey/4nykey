# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="a library to parse and evaluate symbolic expressions input as text"
HOMEPAGE="http://www.gnu.org/software/libmatheval/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-scheme/guile
"
RDEPEND=""

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README THANKS
}
