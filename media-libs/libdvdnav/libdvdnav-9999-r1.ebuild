# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://sourceforge.net/projects/dvd/"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug dvdread"

DEPEND="
	dvdread? ( media-libs/libdvdread )
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	subversion_src_unpack
	mv configure2 configure
}

src_compile() {
	use dvdread && local myconf="--with-dvdread=/usr/include/dvdread"
	econf \
		--extra-cflags="${CFLAGS} -fno-strict-aliasing" \
		--extra-ldflags="${LDFLAGS}" \
		--enable-shared \
		--disable-strip \
		--disable-opts \
		$(use_enable debug) \
		${myconf} \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
