# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font versionator

MY_PV="$(delete_all_version_separators)"
DESCRIPTION="Thryomanes Unicode TrueType font"
HOMEPAGE="http://www.io.com/~hmiller/lang/"
SRC_URI="ftp://ftp.io.com/pub/usr/hmiller/fonts/Thryomanes${MY_PV}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_SUFFIX="TTF"
FONT_S="${S}"
