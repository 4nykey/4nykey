# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/-}"
FONT_SUFFIX="ttf"
if [[ -z ${PV%%*9999} ]]; then
	EBZR_REPO_URI="lp:${MY_PN}"
	inherit bzr
	FONT_SUFFIX="${FONT_SUFFIX} otf"
else
	inherit unpacker
	MY_P="${MY_PN}-${PV}"
	SRC_URI="https://launchpad.net/${MY_PN}/trunk/${PV}/+download/${MY_P}.zip"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
	DEPEND="$(unpacker_src_uri_depends)"
fi
inherit font-r1

DESCRIPTION="A realist sans-serif typeface based on ATF 1908 News Gothic"
HOMEPAGE="https://launchpad.net/newscycle"

LICENSE="OFL-1.1"
SLOT="0"
