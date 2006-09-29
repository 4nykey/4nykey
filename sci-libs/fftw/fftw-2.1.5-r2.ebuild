# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/fftw/fftw-2.1.5-r1.ebuild,v 1.7 2006/09/12 20:48:12 dberkholz Exp $

inherit flag-o-matic multilib

IUSE="mpi"

DESCRIPTION="C subroutine library for computing the Discrete Fourier Transform (DFT)"
SRC_URI="http://www.fftw.org/${P}.tar.gz"
HOMEPAGE="http://www.fftw.org"

DEPEND="mpi? ( >=sys-cluster/lam-mpi-6.5.6 )"
SLOT="2.1"
LICENSE="GPL-2"

KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

pkg_setup() {
	#this one is reported to cause trouble on pentium4 m series
	filter-mfpmath "sse"

	#here I need (surprise) to increase optimization:
	#--enable-i386-hacks requires -fomit-frame-pointer to work properly
	if [ "${ARCH}" != "amd64" ]; then
		is-flag "-fomit-frame-pointer" || append-flags "-fomit-frame-pointer"
	fi

	einfo ""
	einfo "This ebuild installs double and single precision versions of library"
	einfo "This involves some name mangling, as supported by package and required"
	einfo "by some apps that use it."
	einfo "By default, the symlinks to non-mangled names will be created off"
	einfo "double-precision version. In order to symlink to single-precision use"
	einfo "SINGLE=yes emerge fftw"
	einfo ""
}

src_unpack() {
	#doc suggests installing single and double precision versions via separate compilations
	#will do in two separate source trees
	#since some sed'ing is done during the build (?if --enable-type-prefix is set?)

	unpack "${P}.tar.gz"
	cd "${WORKDIR}"
	# give -Wl,--as-needed a hand
	sed -i \
		's:\(la_LIBADD =\):\1 $(top_builddir)/fftw/lib@FFTW_PREFIX@fftw.la:' \
		${P}/rfftw/Makefile.in
	cp -a ${P} ${P}-single
	mv ${P} ${P}-double
}

src_compile() {
	local myconf=""
	use mpi && myconf="${myconf} --enable-mpi"

	if [ "${ARCH}" == "amd64" ]; then
		myconf="${myconf} --disable-i386-hacks"
	else
		myconf="${myconf} --enable-i386-hacks"
	fi

	#mpi is not a valid flag yet. In this revision it is used merely to block --enable-mpi option
	#it might be needed if it is decided that lam is an optional dependence

	cd "${S}-single"
	econf \
		--enable-shared \
		--enable-threads \
		--enable-type-prefix \
		--enable-float \
		--enable-vec-recurse \
		${myconf} || die "./configure failed"
	emake || die

	#the only difference here is no --enable-float
	cd "${S}-double"
	econf \
		--enable-shared \
		--enable-threads \
		--enable-type-prefix \
		--enable-vec-recurse \
		${myconf} || die "./configure failed"
	emake || die
}

src_install () {
	#both builds are installed in the same place
	#libs are distinguished by preffix (s or d), see docs for details
	cd "${S}-single"

	make DESTDIR=${D} install || die

	cd "${S}-double"

	# fix info file
	local infofile
	for infofile in doc/fftw*info*; do
		echo "INFO-DIR-SECTION Libraries" >>${infofile}
		echo "START-INFO-DIR-ENTRY" >>${infofile}
		echo "* fftw: (fftw).                  C subroutine library for computing the Discrete Fourier Transform (DFT)" >>${infofile}
		echo "END-INFO-DIR-ENTRY" >>${infofile}
	done
	make DESTDIR=${D} install || die

	# Install documentation.
	cd "${S}-single"

	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS  TODO
	dohtml doc/fftw*.html

	if [ "$SINGLE" = "yes" ]; then
		cd ${D}usr/include
		dosym sfftw.h /usr/include/fftw.h
		dosym srfftw.h /usr/include/rfftw.h
		dosym sfftw_threads.h /usr/include/fftw_threads.h
		dosym srfftw_threads.h /usr/include/rfftw_threads.h
		cd ${D}usr/$(get_libdir)
		dosym libsfftw.so /usr/$(get_libdir)/libfftw.so
		dosym libsrfftw.so /usr/$(get_libdir)/librfftw.so
		dosym libsfftw_threads.so /usr/$(get_libdir)/libfftw_threads.so
		dosym libsrfftw_threads.so /usr/$(get_libdir)/librfftw_threads.so
	else
		cd ${D}usr/include
		dosym dfftw.h /usr/include/fftw.h
		dosym drfftw.h /usr/include/rfftw.h
		dosym dfftw_threads.h /usr/include/fftw_threads.h
		dosym drfftw_threads.h /usr/include/rfftw_threads.h
		cd ${D}usr/$(get_libdir)
		dosym libdfftw.so /usr/$(get_libdir)/libfftw.so
		dosym libdrfftw.so /usr/$(get_libdir)/librfftw.so
		dosym libdfftw_threads.so /usr/$(get_libdir)/libfftw_threads.so
		dosym libdrfftw_threads.so /usr/$(get_libdir)/librfftw_threads.so
	fi

	cd "${S}-single/fortran"
	insinto usr/include
	doins fftw_f77.i
}
