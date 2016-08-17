# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

if [[ ${PV} == *9999* ]]; then
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
	DEPEND="
		media-gfx/fontforge[python]
		media-gfx/xgridfit
	"
else
	SRC_URI="https://${PN}.googlecode.com/files/${PN}-ttf-r${PV}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font

DESCRIPTION="Edrip font is a contrast sans-serif font based on the Teams font"
HOMEPAGE="http://code.google.com/p/edrip"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

FONT_SUFFIX="ttf"
DOCS=( FontLog.txt README )
RESTRICT="primaryuri"
