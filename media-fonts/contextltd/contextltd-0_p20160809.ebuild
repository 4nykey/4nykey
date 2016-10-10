# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Fonts by Context Ltd"
HOMEPAGE="http://openfontlibrary.org/en/search?query=Context+Ltd"
SRC_URI="mirror://fontlibrary/"
SRC_URI="
	${SRC_URI}bretan/4c03c53817dacd059f28f385af02c5e8/bretan.zip
	-> ${PN}-bretan-2016-04-11.zip
	${SRC_URI}bretan-pro/64bd884a92bfa6dbf138bfaab0730c43/bretan-pro.zip
	-> ${PN}-bretan-pro-2014-12-19.zip
	${SRC_URI}libra-sans/f603cd30e6aad824e4dd78e06303b91f/libra-sans.zip
	-> ${PN}-libra-sans-2015-03-13.zip
	${SRC_URI}libra-sans-modern/13740f175661b2eeb8442a7f55c7df37/libra-sans-modern.zip
	-> ${PN}-libra-sans-modern-2016-06-09.zip
	${SRC_URI}libra-serif-modern/c4e1a594856aa86de73232004f7a2c14/libra-serif-modern.zip
	-> ${PN}-libra-serif-modern-2016-08-08.zip
	${SRC_URI}linguistics-pro/425914a80ff1bddc48ab57e8df0fe4df/linguistics-pro.zip
	-> ${PN}-linguistics-pro-2016-08-09.zip
	${SRC_URI}perun/f599d235c8bd2e58a318a840d0a4b43d/perun.zip
	-> ${PN}-perun-2016-05-10.zip
	${SRC_URI}pliska/4d557090575c09e18be2902ef5f153eb/pliska.zip
	-> ${PN}-pliska-2016-08-01.zip
	${SRC_URI}repo/79e09122296134459d9d2e07e87526e4/repo.zip
	-> ${PN}-repo-2016-03-31.zip
	${SRC_URI}selena/2408edf9dff3fa57b6c457b5380986b6/selena.zip
	-> ${PN}-selena-2014-12-16.zip
	${SRC_URI}sibila/8a89a44e0e9bb20a3a99560d1832f0cd/sibila.zip
	-> ${PN}-sibila-2014-12-16.zip
	${SRC_URI}tipotype/f878a50ead6d3196d62cd1959b5ad96e/tipotype.zip
	-> ${PN}-tipotype-2014-12-17.zip
	${SRC_URI}veleka/584f559fc3138f92770b06014a7c119c/veleka.zip
	-> ${PN}-veleka-2016-08-04.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="
	$(printf '+font_types_%s ' ${FONT_TYPES})
"

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""
DOCS="*_Description.txt"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	font_pkg_setup
}
