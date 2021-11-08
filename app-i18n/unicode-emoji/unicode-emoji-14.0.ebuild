# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="UTS #51 Unicode Emoji"
HOMEPAGE="https://unicode.org/emoji/techindex.html"
DATA_URI="https://unicode.org/Public/${PN#*-}/${PV}"
UCD_PV="$(ver_cut 1).0"
UCD_URI="https://unicode.org/Public/${UCD_PV}.0/ucd/${PN#*-}"
SRC_URI="
	${DATA_URI}/${PN#*-}-sequences.txt -> ${PN}-sequences-${PV}.txt
	${DATA_URI}/${PN#*-}-test.txt -> ${PN}-test-${PV}.txt
	${DATA_URI}/${PN#*-}-zwj-sequences.txt -> ${PN}-zwj-sequences-${PV}.txt
	${UCD_URI}/${PN#*-}-data.txt -> ${PN}-data-${UCD_PV}.txt
	${UCD_URI}/${PN#*-}-variation-sequences.txt -> ${PN}-variation-sequences-${UCD_PV}.txt
"

LICENSE="unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	local a
	insinto /usr/share/${PN/-//}
	for a in ${A}; do
		newins "${DISTDIR}"/${a} $(echo ${a} | sed "s/${PN%-*}-\(.*\)-${PV}/\1/")
	done
}
