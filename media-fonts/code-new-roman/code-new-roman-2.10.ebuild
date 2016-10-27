# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

S="${WORKDIR}"
inherit font-r1

DESCRIPTION="A monospace font"
HOMEPAGE="http://typostyle.com"
SRC_URI="mirror://sourceforge/codenewroman/cnr_BETA.otf -> ${P}.otf"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="otf"

src_unpack() {
	cp "${DISTDIR}"/${A} "${S}"/
}
