# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="XSerif Unicode TruType font"
HOMEPAGE="http://www.slovo.info/xserif.htm"
SRC_URI="http://www.slovo.info/Download/xsuni.zip"
S="${WORKDIR}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_SUFFIX="ttf"
FONT_S="${S}"
