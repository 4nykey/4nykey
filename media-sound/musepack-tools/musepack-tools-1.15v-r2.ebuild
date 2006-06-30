# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musepack-tools/musepack-tools-1.15s-r2.ebuild,v 1.1 2005/01/17 20:52:11 chainsaw Exp $

IUSE="static esd 16bit encode oss"

inherit eutils flag-o-matic #subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
#ESVN_REPO_URI="http://svn.musepack.net/trunk"
#ESVN_PATCHES="${FILESDIR}/${PN}-*.diff"
SRC_URI="http://files.musepack.net/source/mpcsv7-src-${PV}.tar.bz2"
S="${WORKDIR}/sv7"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"

RDEPEND="esd? ( media-sound/esound )
	 media-libs/id3lib"

DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
	amd64? ( dev-lang/nasm )"

src_unpack() {
	unpack ${A}

	cd ${S}

	epatch ${FILESDIR}/${PN}-*.diff
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
