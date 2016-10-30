# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

S="${WORKDIR}"
inherit font-r1 versionator

MY_PV="$(replace_all_version_separators -)"
DESCRIPTION="Gandhari Unicode Roman true-type font"
HOMEPAGE="http://andrewglass.org/fonts.php"
SRC_URI="http://andrewglass.org/downloads/gu${MY_PV}_ttf.zip"
RESTRICT="primaryuri"

LICENSE="Aladdin GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"
