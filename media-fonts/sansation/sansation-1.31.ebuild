# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit font-r1

DESCRIPTION="A slightly squared sans serif typeface aimed to look unique"
HOMEPAGE="http://www.dafont.com/${PN}.font"
SRC_URI="http://dl.dafont.com/dl/?f=${PN} -> ${P}.zip"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
S="${WORKDIR}"
DOCS=( ${PN^}_${PV}_ReadMe.txt )
