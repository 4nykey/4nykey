# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}/TTF"
inherit font

DESCRIPTION="Free-use OpenType font"
HOMEPAGE="http://01.org/clearsans"
SRC_URI="https://01.org/sites/default/files/downloads/clear-sans/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
FONT_SUFFIX="ttf"
