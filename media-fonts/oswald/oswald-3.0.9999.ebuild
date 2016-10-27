# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vernnobile/OswaldFont.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/vernnobile/OswaldFont/tar.gz/9dd0521c8c06dd24998fe5d9cd644dab9cbbacca
		-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
inherit versionator font-r1

DESCRIPTION="A reworking of the classic gothic typeface style"
HOMEPAGE="http://oswaldfont.com"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

S="${WORKDIR}/${P}/$(get_version_component_range -2)"
FONT_SUFFIX="ttf otf"
FONT_S=( {Italic,Roman}/{2,3,4,5,6,7,8}00 )
