# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Fonts by Jovanny Lemonad"
HOMEPAGE="http://jovanny.ru/"
SRC_URI="
${HOMEPAGE}fonts/20db.rar
${HOMEPAGE}fonts/Cuprum_typefamily.zip
${HOMEPAGE}fonts/Days.rar
${HOMEPAGE}fonts/Dited.rar
${HOMEPAGE}fonts/flow.rar
${HOMEPAGE}fonts/Imperial.zip
${HOMEPAGE}fonts/London.rar
${HOMEPAGE}fonts/Metro.rar
${HOMEPAGE}fonts/Molot.rar
${HOMEPAGE}fonts/neucha.rar
${HOMEPAGE}fonts/Oranienbaum.zip
${HOMEPAGE}fonts/Philosopher.zip
${HOMEPAGE}fonts/Prosto.rar
${HOMEPAGE}fonts/Russo.zip
${HOMEPAGE}fonts/Stalinist.zip
${HOMEPAGE}fonts/Underdog.zip
${HOMEPAGE}fonts/Yeseva.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""
FONT_SUFFIX="otf ttf"
