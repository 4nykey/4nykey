# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

MY_PN="lib-ka"
DESCRIPTION="Liberastika fonts are fork of Liberation Sans"
HOMEPAGE="http://lib-ka.sf.net"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tar.xz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
