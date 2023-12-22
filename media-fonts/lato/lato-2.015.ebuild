# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LICENSE="OFL-1.1"
MY_PN="${PN^}${PV%.*}${LICENSE%-*}"
inherit font-r1

DESCRIPTION="A sanserif typeface family with classical proportions"
HOMEPAGE="https://www.latofonts.com"
SRC_URI="
	http://distcache.freebsd.org/ports-distfiles/lato/${MY_PN}.zip
	https://www.latofonts.com/files/${MY_PN}.zip
"
RESTRICT="primaryuri"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
S="${WORKDIR}/${MY_PN}"
