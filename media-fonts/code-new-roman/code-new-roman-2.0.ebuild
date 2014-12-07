# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font

MY_P="Code_New_Roman${PV}"
DESCRIPTION="Code New Roman is a monospace font"
HOMEPAGE="http://fb.com/Code.New.Roman"
SRC_URI="http://bemybux.hostingsiteforfree.com/sm/cnr/download/${MY_P}.zip"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="otf"
DOCS="cnr-note.txt"
