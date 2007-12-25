# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/dillo/dillo-0.8.6.ebuild,v 1.1 2006/09/10 23:08:04 exg Exp $

inherit cvs autotools

DILLO_I18N_P="dillo-0.8.6-i18n-misc-20070916.diff"
DILLO_GENTOO_P="dillo-gentoo-extras-patch4"

DESCRIPTION="Lean GTK+-based web browser"
HOMEPAGE="http://www.dillo.org/"
SRC_URI="
	mirror://gentoo/${DILLO_GENTOO_P}.tar.bz2
	http://teki.jpn.ph/pc/software/${DILLO_I18N_P}.bz2
"
ECVS_SERVER="auriga.wearlab.de:/sfhome/cvs/dillo"
ECVS_MODULE="dillo"
S="${WORKDIR}/${ECVS_MODULE}"
S2="${WORKDIR}/${DILLO_GENTOO_P}"

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

	einfo "Applying ${DILLO_I18N_P} ..."
	patch ${EPATCH_OPTS} -p1 -f -s < "${WORKDIR}"/${DILLO_I18N_P} > \
		"${T}"/${DILLO_I18N_P}.out 2>&1
	eend 0
	epatch "${FILESDIR}"/${PN}-*.diff
	AT_M4DIR=m4 eautoreconf

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
	econf \
		--disable-gtktest \
		--enable-tabs \
		--enable-meta-refresh \
		$(use_enable nls) \
		$(use_enable truetype anti-alias) \
		$(use_enable fltk dlgui) \
		$(use_enable ipv6) \
		$(use_enable ssl) \
		|| die
	emake -j1 || die
}

src_install() {
	einstall MKINSTALLDIRS=${S}/mkinstalldirs || die

	dodoc AUTHORS ChangeLog* README NEWS
	docinto doc
	dodoc doc/*.txt doc/README

	insinto /usr/share/icons/${PN}
	doins ${S2}/icons/*.png
}

pkg_postinst() {
	cat "${FILESDIR}"/iconset_msg | while read m; do elog ${m}; done
}
