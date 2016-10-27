# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

S="${WORKDIR}"
inherit font-r1 unpacker

DESCRIPTION="Free fonts project aiming to make free typography more popular"
HOMEPAGE="http://www.typetype.ru/free-fonts"
SRC_URI="http://www.typetype.ru/files/fonts/"
SRC_URI="
	${SRC_URI}20db.rar
	${SRC_URI}accuratist.zip
	${SRC_URI}airport.rar
	${SRC_URI}ardeco.zip
	${SRC_URI}bender.zip
	${SRC_URI}bicubik.rar
	${SRC_URI}bristol.zip
	${SRC_URI}bully.zip
	${SRC_URI}captcha_code.zip
	${SRC_URI}cuprum_typefamily.zip
	${SRC_URI}days.rar
	${SRC_URI}dita-sweet.zip
	${SRC_URI}dited.rar
	${SRC_URI}eleventh.zip
	${SRC_URI}epool.rar
	${SRC_URI}flow.rar
	${SRC_URI}fontinsans_cyrillic_46b.zip
	${SRC_URI}freeride.zip
	${SRC_URI}frenchpress.zip
	${SRC_URI}furore.rar
	${SRC_URI}hardpixel.rar
	${SRC_URI}hattori.zip
	${SRC_URI}hitch-hike.zip
	${SRC_URI}imperial.zip
	${SRC_URI}insektofobiya.zip
	${SRC_URI}kazmann.zip
	${SRC_URI}lemon_tuesday.zip
	${SRC_URI}london.rar
	${SRC_URI}lumberjack.zip
	${SRC_URI}magnolia_script.zip
	${SRC_URI}matias_freefont.zip
	${SRC_URI}metro.rar
	${SRC_URI}molot.zip
	${SRC_URI}neucha.rar
	${SRC_URI}nixie.zip
	${SRC_URI}oranienbaum.zip
	${SRC_URI}otscookie.rar
	${SRC_URI}peace_sans.zip
	${SRC_URI}philosopher.zip
	${SRC_URI}prosto.zip
	${SRC_URI}puzzle.rar
	${SRC_URI}romochka.zip
	${SRC_URI}russo.zip
	${SRC_URI}scada_font.zip
	${SRC_URI}stalinist.zip
	${SRC_URI}steamy.zip
	${SRC_URI}suwikisu.rar
	${SRC_URI}underdog.zip
	${SRC_URI}unimportant.rar
	${SRC_URI}upheaval.rar
	${SRC_URI}ussr_stencil.zip
	${SRC_URI}wes.zip
	${SRC_URI}yeseva.zip
	${SRC_URI}zhizn.rar
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
FONT_SUFFIX="otf ttf"
FONT_S=( inst )
DOCS="inst/*.pdf"

src_prepare() {
	default
	mkdir -p "${FONT_S}"
	rm -rf "${S}"/__MACOSX
	find "${S}" -type f \
		-ipath '*.[otp][dt]f' -! -ipath '*webfont*' \
		-exec mv {} "${FONT_S}" \;
}
