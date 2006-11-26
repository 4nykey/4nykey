# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_/-}
DESCRIPTION="Extremely fast and lightweight tabbed file manager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="hal fam"

RDEPEND="
	>=x11-libs/gtk+-2.6
	x11-libs/startup-notification
	hal? (
		|| (
			dev-libs/dbus-glib
			<sys-apps/dbus-0.90
		)
		>=sys-apps/hal-0.5
	)
	fam? ( virtual/fam )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_compile() {
	econf \
		$(use_enable hal) \
		$(use_enable fam inotify) \
	|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS TODO
}
