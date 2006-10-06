# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/mppenc/trunk"
ESVN_PATCHES="${FILESDIR}/${PN}-*.diff"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"
IUSE="static esd 16bit encode oss"

RDEPEND="
	esd? ( media-sound/esound )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
	amd64? ( dev-lang/nasm )
"

src_unpack() {
	subversion_src_unpack
	cd ${S}

	sed -i \
		'/USE_IRIX_AUDIO/d; /USE_ESD_AUDIO/d; /USE_OSS_AUDIO/d; /USE_ASM/d' \
		mpp.h
	use 16bit && sed -i 's|//#define MAKE_16BIT|#define MAKE_16BIT|' mpp.h

	cp ${FILESDIR}/Makefile .
	mv replaygain.c.new replaygain.c
}

src_compile() {
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-mfpmath=sse" "-mfpmath=sse,387"

	use static && export BLD_STATIC=1
	use esd && export USE_ESD=1
	use oss && export USE_OSS=1
	[[ $(tc-arch) == "x86" ]] && export USE_ASM=1
	use encode && MPPENC="mppenc"

	emake CC="$(tc-getCC)" ${MPPENC} mppdec replaygain || die
}

src_install() {
	dobin ${MPPENC} mppdec replaygain
	dodoc README doc/ChangeLog doc/MANUAL.TXT doc/NEWS doc/SV7.txt doc/TODO*
}
