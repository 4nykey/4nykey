# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musepack-tools/musepack-tools-1.15s-r2.ebuild,v 1.1 2005/01/17 20:52:11 chainsaw Exp $

IUSE="static esd 16bit encode"

inherit eutils flag-o-matic subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.uni-jena.de/~pfk/mpp/ http://corecodec.org/projects/mpc/ http://www.musepack.net"
ESVN_REPO_URI="http://svn.caddr.com/svn/${PN}/trunk"
ESVN_PATCHES="${FILESDIR}/*.diff"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86"

RDEPEND="esd? ( media-sound/esound )
	 media-libs/id3lib"

DEPEND="${RDEPEND}
	virtual/os-headers
	x86? ( dev-lang/nasm )
	amd64? ( dev-lang/nasm )"

src_unpack() {
	subversion_src_unpack
	cd ${S}

	sed -i 's/#define USE_IRIX_AUDIO/#undef USE_IRIX_AUDIO/' mpp.h
	if ! use esd ; then
		sed -i 's/#define USE_ESD_AUDIO/#undef USE_ESD_AUDIO/' mpp.h
	else
		sed -i 's/#LDADD   += -lesd/LDADD   += -lesd/' Makefile
	fi
	if ! use x86 ; then
		sed -i 's/#define USE_ASM/#undef USE_ASM/' mpp.h
	fi
	use 16bit && sed -i 's|//#define MAKE_16BIT|#define MAKE_16BIT|' mpp.h

	mv replaygain.c.new replaygain.c
}

src_compile() {
	strip-flags
	filter-flags "-mfpmath=sse" "-mfpmath=sse,387"
	use static && export BLD_STATIC=1
	use encode && MPPENC="mppenc"
	ARCH="${CFLAGS}" CFLAGS= emake ${MPPENC} mppdec replaygain || die
}

src_install() {
	dobin ${MPPENC} mppdec replaygain
	dodoc COPYING* README doc/ChangeLog doc/MANUAL.TXT doc/NEWS doc/SV7.txt doc/TODO*
}
