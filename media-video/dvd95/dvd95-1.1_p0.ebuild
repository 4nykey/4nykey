# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="DVD95 is an gnome application to convert DVD9 to DVD5."
HOMEPAGE="http://dvd95.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mmx 3dnow sse sse2"

DEPEND="gnome-base/libgnomeui
    media-libs/libdvdread"

RDEPEND="gnome-base/libgnomeui
    media-libs/libdvdread"

src_compile() {
	sed -i '/-O3/d' configure
	econf \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable sse2) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	dosed 's:local/::' /usr/share/applications/dvd95.desktop
}

