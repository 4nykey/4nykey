# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk"
	DEPEND="
		media-gfx/fontforge[python]
		media-gfx/xgridfit
	"
else
	S="${WORKDIR}"
	inherit font
	SRC_URI="https://${PN}.googlecode.com/files/${PN}-ttf-r${PV}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Edrip font is a contrast sans-serif font based on the Teams font"
HOMEPAGE="http://code.google.com/p/edrip"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

FONT_SUFFIX="ttf"
DOCS="FontLog.txt README"
