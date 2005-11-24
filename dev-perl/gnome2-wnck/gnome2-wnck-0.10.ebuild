# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

IUSE=""
inherit perl-module eutils

MY_P="Gnome2-Wnck-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Perl interface to the Window Navigator Construction Kit"
SRC_URI="mirror://sourceforge/gtk2-perl/${MY_P}.tar.gz"
HOMEPAGE="http://gtk2-perl.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=dev-perl/glib-perl-1.042
	>=dev-perl/gtk2-perl-1.042
	>=x11-libs/libwnck-2
	dev-perl/extutils-pkgconfig
	>=dev-perl/extutils-depends-0.2*"

src_unpack() {
	unpack ${A}
	cd ${S}
}

