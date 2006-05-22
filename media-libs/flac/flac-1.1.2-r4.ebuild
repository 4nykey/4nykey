# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.2-r3.ebuild,v 1.2 2005/10/19 19:05:09 metalgod Exp $

inherit libtool cvs autotools

PATCHLEVEL="3"
DESCRIPTION="free lossless audio encoder which includes an XMMS plugin"
HOMEPAGE="http://flac.sourceforge.net/"
#SRC_URI="mirror://sourceforge/flac/${P}.tar.gz
SRC_URI="mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"
ECVS_SERVER="flac.cvs.sourceforge.net:/cvsroot/flac"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="3dnow debug doc ogg sse xmms pic"

RDEPEND="ogg? ( >=media-libs/libogg-1.0_rc2 )
	xmms? ( media-sound/xmms )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	rm -f ${WORKDIR}/patches/{01,02,03,09,10}0*.patch
	cvs_src_unpack
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	AT_M4DIR="m4" eautoreconf
	elibtoolize
}

src_compile() {
	use doc || export ac_cv_prog_DOXYGEN=''
	econf \
		$(use_enable ogg) \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable debug) \
		$(use_enable doc) $(use_enable doc doxygen-docs) \
		$(use_with pic) \
		--disable-dependency-tracking || die

	# the man page ebuild requires docbook2man... yick!
	sed -i -e 's:include man:include:g' Makefile

	# parallel make seems to mess up the building of the xmms input plugin
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" docdir="/usr/share/doc/${PF}" \
		install || die "make install failed"
	dodoc AUTHORS README

	doman man/{flac,metaflac}.1
}

pkg_postinst() {
	ewarn "If you've upgraded from a previous version of flac, you may need to re-emerge"
	ewarn "packages that linked against flac by running:"
	ewarn "revdep-rebuild"
}

# see #59482
src_test() { :; }
