# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font versionator

MY_PV="$(replace_all_version_separators _)"
MY_P="NAU${MY_PV}ttf"
DESCRIPTION="New Athena Unicode true-type font"
HOMEPAGE="http://socrates.berkeley.edu/~pinax/greekkeys/NAUdownload.html"
SRC_URI="http://socrates.berkeley.edu/~pinax/greekkeys/fonts/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="*.rtf"
FONT_SUFFIX="ttf"
FONT_S="${S}"
