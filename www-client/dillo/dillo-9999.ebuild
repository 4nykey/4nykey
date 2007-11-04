# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/dillo/dillo-0.8.6.ebuild,v 1.1 2006/09/10 23:08:04 exg Exp $

inherit cvs autotools

S2=${WORKDIR}/dillo-gentoo-extras-patch4
DILLO_I18N_P="${PN}-0.8.6-i18n-misc-20060709"

DESCRIPTION="Lean GTK+-based web browser"
HOMEPAGE="http://www.dillo.org/"
SRC_URI="
	mirror://gentoo/dillo-gentoo-extras-patch4.tar.bz2
	http://teki.jpn.ph/pc/software/${DILLO_I18N_P}.diff.bz2
"
ECVS_SERVER="auriga.wearlab.de:/sfhome/cvs/dillo"
ECVS_MODULE="dillo"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls truetype ipv6 ssl fltk"

RDEPEND="
	=x11-libs/gtk+-1.2*
	>=media-libs/jpeg-6b
	>=sys-libs/zlib-1.1.3
	>=media-libs/libpng-1.2.1
	ssl? ( dev-libs/openssl )
	fltk? ( =x11-libs/fltk-2* )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_unpack() {
	unpack ${A}
	cvs_src_unpack
	cd ${S}
	patch ${EPATCH_OPTS} -p1 -f -s < "${WORKDIR}"/${DILLO_I18N_P}.diff > \
		"${T}"/${DILLO_I18N_P}.diff.out 2>&1

	# -Wl,--as-needed
	sed -i "s:\<LDFLAGS\>:LIBS:g; s:\<LDSAVEFLAGS\>:LIBSSAVE:g" configure.in

	sed -i "s:fltk-config:fltk2-config:" configure.in
	eautoreconf

	if [ "${DILLO_ICONSET}" = "kde" ]
	then
		einfo "Using Konqueror style icon set"
		cp ${S2}/pixmaps.konq.h ${S}/src/pixmaps.h
	elif [ "${DILLO_ICONSET}" = "gnome" ]
	then
		einfo "Using Ximian style icon set"
		cp ${S2}/pixmaps.ximian.h ${S}/src/pixmaps.h
	elif [ "${DILLO_ICONSET}" = "mozilla" ]
	then
		einfo "Using Netscape style icon set"
		cp ${S2}/pixmaps.netscape.h ${S}/src/pixmaps.h
	elif [ "${DILLO_ICONSET}" = "cobalt" ]
	then
		einfo "Using Cobalt style icon set"
		cp ${S2}/pixmaps.cobalt.h ${S}/src/pixmaps.h
	elif [ "${DILLO_ICONSET}" = "bold" ]
	then
		einfo "Using bold style icon set"
		cp ${S2}/pixmaps.bold.h ${S}/src/pixmaps.h
	elif [ "${DILLO_ICONSET}" = "trans" ]
	then
		einfo "Using transparent style icon set"
		cp ${S2}/pixmaps.trans.h ${S}/src/pixmaps.h
	elif [ "${DILLO_ICONSET}" = "trad" ]
	then
		einfo "Using the traditional icon set"
		cp ${S2}/pixmaps.trad.h ${S}/src/pixmaps.h
	else
		einfo "Using default Dillo icon set"
	fi
}

src_compile() {
	local myconf

	# misc features
	myconf="$(use_enable nls)
		$(use_enable truetype anti-alias)
		--disable-gtktest
		$(use_enable fltk dlgui)
		--enable-tabs
		--enable-meta-refresh"

	myconf="${myconf}
		$(use_enable ipv6)
		$(use_enable ssl)"

	econf ${myconf} || die
	emake -j1 || die
}

src_install() {
	make DESTDIR=${D} MKINSTALLDIRS=${S}/mkinstalldirs install || die

	dodoc AUTHORS COPYING ChangeLog* README NEWS
	docinto doc
	dodoc doc/*.txt doc/README

	insinto /usr/share/icons/${PN}
	doins ${S2}/icons/*.png
}

pkg_postinst() {
	einfo "This ebuild for dillo comes with different toolbar icons"
	einfo "If you want mozilla style icons then try"
	einfo "	DILLO_ICONSET=\"mozilla\" emerge dillo"
	einfo
	einfo "If you prefer konqueror style icons then try"
	einfo "	DILLO_ICONSET=\"kde\" emerge dillo"
	einfo
	einfo "If you prefer ximian gnome style icons then try"
	einfo "	DILLO_ICONSET=\"gnome\" emerge dillo"
	einfo
	einfo "If you prefer cobalt style icons then try"
	einfo "	DILLO_ICONSET=\"cobalt\" emerge dillo"
	einfo
	einfo "If you prefer bold style icons then try"
	einfo "	DILLO_ICONSET=\"bold\" emerge dillo"
	einfo
	einfo "If you prefer transparent style icons then try"
	einfo "	DILLO_ICONSET=\"trans\" emerge dillo"
	einfo
	einfo "If you prefer the traditional icons then try"
	einfo "	DILLO_ICONSET=\"trad\" emerge dillo"
	einfo
	einfo "If the DILLO_ICONSET variable is not set, you will get the"
	einfo "default iconset"
	einfo
	einfo "To see what the icons look like, please point your browser to:"
	einfo "http://dillo.auriga.wearlab.de/Icons/"
	einfo
}
