# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.2-r5.ebuild,v 1.2 2006/05/28 02:16:10 flameeyes Exp $

inherit cvs autotools toolchain-funcs

DESCRIPTION="Free Lossless Audio Encoder"
HOMEPAGE="http://flac.sourceforge.net/"
ECVS_SERVER="flac.cvs.sourceforge.net:/cvsroot/flac"
ECVS_MODULE="flac"
S="${WORKDIR}/${ECVS_MODULE}"
RESTRICT="test" # see #59482

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="3dnow debug doc ogg sse pic"

RDEPEND="
	ogg? ( >=media-libs/libogg-1.0_rc2 )
"
DEPEND="
	${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk
	doc? (
		app-doc/doxygen
		app-text/docbook-sgml-utils
	)
	dev-util/pkgconfig
	sys-devel/gettext
"

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-*.diff
	install /usr/share/gettext/config.rpath .
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		$(use_enable ogg) \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_with pic) \
		--disable-thorough-tests \
		--disable-dependency-tracking \
		|| die

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" docdir="/usr/share/doc/${PF}/html" \
		install || die "make install failed"
	dodoc AUTHORS README

	doman man/{flac,metaflac}.1
}

pkg_postinst() {
	ewarn "If you've upgraded from a previous version of flac, you may need to re-emerge"
	ewarn "packages that linked against flac by running:"
	ewarn "revdep-rebuild"
}
