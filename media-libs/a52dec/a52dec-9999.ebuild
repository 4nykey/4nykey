# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/a52dec/a52dec-0.7.4-r1.ebuild,v 1.5 2004/07/29 02:55:52 tgall Exp $

EAPI="4"

inherit cvs autotools-utils

DESCRIPTION="library for decoding ATSC A/52 streams used in DVD"
HOMEPAGE="http://liba52.sourceforge.net/"
ECVS_SERVER="liba52.cvs.sourceforge.net:/cvsroot/liba52"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="oss djbfft"

AUTOTOOLS_AUTORECONF="1"
PATCHES=("${FILESDIR}"/${PN}*.diff)
DOCS=(AUTHORS ChangeLog HISTORY NEWS README TODO doc/liba52.txt)

DEPEND="
	djbfft? ( sci-libs/djbfft )
	oss? ( virtual/os-headers )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable djbfft)
		$(use_enable oss)
	)
	autotools-utils_src_configure
}
