# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Fonts by Context Ltd"
HOMEPAGE="http://openfontlibrary.org/en/search?query=Context+Ltd"
BASE_URI="http://openfontlibrary.org/assets/downloads/"
SRC_URI="
${BASE_URI}bretan/79f39f3224dd7db0aae8fca528dac1a4/bretan.zip -> ${PN}-bretan-2015-01-22.zip
${BASE_URI}libra-sans/659fd41013b5a74ecba65a340ed9bb4a/libra-sans.zip -> ${PN}-libra-sans-2015-01-31.zip
${BASE_URI}selena/2408edf9dff3fa57b6c457b5380986b6/selena.zip -> ${PN}-selena-2014-12-16.zip
${BASE_URI}sibila/8a89a44e0e9bb20a3a99560d1832f0cd/sibila.zip -> ${PN}-sibila-2014-12-16.zip
${BASE_URI}tipotype/f878a50ead6d3196d62cd1959b5ad96e/tipotype.zip -> ${PN}-tipotype-2014-12-17.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""
FONT_SUFFIX="otf ttf"
DOCS="*_Description.txt"
