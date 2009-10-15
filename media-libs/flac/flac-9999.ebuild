# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.2-r5.ebuild,v 1.2 2006/05/28 02:16:10 flameeyes Exp $

EAPI="2"

inherit autotools toolchain-funcs cvs

DESCRIPTION="Free Lossless Audio Encoder"
HOMEPAGE="http://flac.sourceforge.net/"
ECVS_SERVER="flac.cvs.sourceforge.net:/cvsroot/flac"
ECVS_MODULE="flac"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="3dnow debug doc +ogg sse +cxx apidocs"

RDEPEND="
	ogg? ( >=media-libs/libogg-1.0_rc2 )
"
DEPEND="
	${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk
	apidocs? ( app-doc/doxygen )
	doc? ( app-text/docbook-sgml-utils )
	dev-util/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-*.diff
	install /usr/share/gettext/config.rpath .
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable ogg) \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable apidocs doxygen-docs) \
		$(use_enable cxx cpplibs) \
		--disable-thorough-tests \
		--disable-dependency-tracking \
		--disable-xmms-plugin
}

src_test() {
	if [[ $UID = 0 ]] ; then
		ewarn "Tests will fail if ran as root, skipping."
	else
		emake check || die "tests failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}/html" \
		install || die "make install failed"
	dodoc AUTHORS README
}
