# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
S="${WORKDIR}"
inherit font-r1 unpacker

DESCRIPTION="Fonts by 4th february"
HOMEPAGE="http://fonts.4thfebruary.com.ua"
SRC_URI="mirror://fontlibrary/"
SRC_URI="
	${SRC_URI}blogger-sans/6d62f1b83637f460d54133976767d50a/blogger-sans.zip
	-> ${PN}-blogger-sans-2014-12-16.zip
	${SRC_URI}designosaur/20b76920b181bc400c45166473687ed6/designosaur.zip
	-> ${PN}-designosaur-2011-05-26.zip
	${SRC_URI}free-grotesque-web-font/3fd3bfdf68bdfe6155d42971455e5b88/free-grotesque-web-font.zip
	-> ${PN}-free-grotesque-web-font-2014-07-08.zip
	${SRC_URI}monitorica/687a26ae356bc31511a27d9b320eaae3/monitorica.zip
	-> ${PN}-monitorica-2014-09-16.zip
	${SRC_URI}sansus-webissimo/9e7ef959f7aeef22383039a04e56def9/sansus-webissimo.zip
	-> ${PN}-sansus-webissimo-2011-05-18.zip
"
RESTRICT="primaryuri"

LICENSE="CC-BY-ND-3.0 CC-BY-ND-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(unpacker_src_uri_depends)"
FONT_S+=( {.,'Blogger Sans'}/OT-{ps,tt} )
DOCS="readme.txt"
