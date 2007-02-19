# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvu/djvu-3.5.17.ebuild,v 1.12 2006/08/16 14:33:58 corsair Exp $

inherit nsplugins flag-o-matic fdo-mime eutils multilib toolchain-funcs cvs autotools

DESCRIPTION="DjVu viewers, encoders and utilities."
HOMEPAGE="http://djvu.sourceforge.net"
ECVS_SERVER="djvu.cvs.sourceforge.net:/cvsroot/djvu"
ECVS_MODULE="djvulibre-3.5"
S=${WORKDIR}/${ECVS_MODULE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xml qt3 jpeg tiff debug threads nls nsplugin kde"

DEPEND="jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( media-libs/tiff )
	qt3? ( <x11-libs/qt-4 )"

src_unpack() {
	cvs_src_unpack

	cd ${S}
	sed -i 's:-\<s\> ::' {gui/djview,tools,xmltools}/Makefile.in

	# do not break with --as-needed
	sed -i 's:\(acx_pthread_flags="pthread\)s :\1 :' config/acinclude.m4
	# and respect our flagz
	sed -i '/-O[*0-9]/d' config/acinclude.m4

	rm -f aclocal.m4
	AT_M4DIR="config" eautoreconf
}

src_compile() {
	# assembler problems and hence non-building with pentium4 
	# <obz@gentoo.org>
	replace-flags -march=pentium4 -march=pentium3

	if use kde; then
		export kde_mimelnk=/usr/share/mimelnk
	fi

	# When enabling qt it must be compiled with threads. See bug #89544.
	if use qt3 ; then
		QTCONF=" --with-qt --enable-threads "
	elif use threads ; then
		QTCONF=" --enable-threads "
	else
		QTCONF=" --disable-threads "
	fi

	econf --enable-desktopfiles \
		$(use_enable xml xmltools) \
		$(use_with jpeg) \
		$(use_with tiff) \
		$(use_enable nls i18n) \
		$(use_enable debug) \
		${QTCONF} \
		|| die "econf failed"

	if ! use nsplugin; then
		sed -e 's:nsdejavu::' -i ${S}/gui/Makefile || die
	fi

	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} plugindir=/usr/$(get_libdir)/${PLUGINS_DIR} install
}
