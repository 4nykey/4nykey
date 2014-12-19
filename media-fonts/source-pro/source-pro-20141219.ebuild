# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/source-pro/source-pro-20130316.ebuild,v 1.2 2013/10/21 12:18:39 grobian Exp $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

CODE_PN="source-code-pro"
CODE_PV="1.017R"
SERI_PN="source-serif-pro"
SERI_PV="1.017R"
SANS_PN="source-sans-pro"
SANS_PV="2.010R-ro/1.065R-it"
CJK_PN="source-han-sans"
CJK_PV="1.001R"

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html"
SRC_URI="
	https://codeload.github.com/adobe-fonts/${CODE_PN}/tar.gz/${CODE_PV} -> ${CODE_PN}-${CODE_PV}.tar.gz
	https://codeload.github.com/adobe-fonts/${SERI_PN}/tar.gz/${SERI_PV} -> ${SERI_PN}-${SERI_PV}.tar.gz
	https://codeload.github.com/adobe-fonts/${SANS_PN}/tar.gz/${SANS_PV} -> ${SANS_PN}-${SANS_PV/\//-}.tar.gz
	cjk? ( https://codeload.github.com/adobe-fonts/${CJK_PN}/tar.gz/${CJK_PV} -> ${CJK_PN}-${CJK_PV}.tar.gz )
"

LICENSE="OFL-1.1 cjk? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="~alpha ~x86"
IUSE="cjk"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

RDEPEND="media-libs/fontconfig"
DEPEND="cjk? ( app-arch/unzip )"

FONT_SUFFIX="otf ttf"
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )

src_unpack() {
	default
	if use cjk; then
		FONT_SUFFIX="${FONT_SUFFIX} ttc"
		unpack_zip "${S}"/${CJK_PN}-${CJK_PV}/SuperOTC/SourceHanSans.ttc.zip
	fi
}

src_prepare() {
	find \
		"${CODE_PN}-${CODE_PV}" "${SERI_PN}-${SERI_PV}" "${SANS_PN}-${SANS_PV/\//-}"\
		-mindepth 2 -name '*.[ot]tf' -exec mv -f {} "${S}" \;
}

src_install() {
	font_src_install
	dohtml */*.html
	use cjk && dodoc "${CJK_PN}-${CJK_PV}"/*.pdf
}
