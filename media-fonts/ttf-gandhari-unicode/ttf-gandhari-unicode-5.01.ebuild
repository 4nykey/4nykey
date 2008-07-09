# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font versionator

MY_PV="$(replace_all_version_separators -)"
DESCRIPTION="Gandhari Unicode Roman true-type font"
HOMEPAGE="http://andrewglass.org/fonts.php"
SRC_URI="
opentype? ( http://andrewglass.org/downloads/gu${MY_PV}.zip )
!opentype? ( http://andrewglass.org/downloads/gu${MY_PV}_ttf.zip )
"
S="${WORKDIR}"

LICENSE="Aladdin GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="opentype"

DOCS="README.txt"
DEPEND="app-arch/unzip"
RDEPEND=""

FONT_SUFFIX="ttf"
use opentype && FONT_SUFFIX="otf"
FONT_S="${S}"
