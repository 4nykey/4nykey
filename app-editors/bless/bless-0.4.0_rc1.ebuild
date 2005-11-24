# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit tla eutils mono
inherit eutils mono

MY_P="${P/_/-}"
DESCRIPTION="Bless is a high quality, full featured hex editor, written in mono/Gtk#."
HOMEPAGE="http://home.gna.org/bless/"
SRC_URI="http://download.gna.org/bless/${MY_P}.tar.gz"
#ETLA_VERSION="alf82@freemail.gr--2004-signed/bless--main"
#ETLA_ARCHIVES="http://arch.gna.org/bless/archive-2004"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.1.4
	>=dev-dotnet/gtk-sharp-1.0.8
	>=dev-dotnet/glade-sharp-1.0.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	sed -i 's:1\.0\.8:1.0.6:g' ${S}/configure
	sed -i 's:AboutDialog:Bless.Gui.Dialogs.AboutDialog:' ${S}/src/gui/MainWindow.cs
}

src_compile() {
	econf --without-scrollkeeper || die
	emake || die
}

src_install() {
	dodir /usr/bin
	einstall || die
	rm -f ${D}usr/bin/bless
	exeinto /usr/bin
	doexe ${FILESDIR}/bless
	dosed "s:@LIB@:$(get_libdir):; s:@PROG@:${MY_P}:" /usr/bin/bless
	dodoc AUTHORS ChangeLog NEWS README
	rm -rf ${D}usr/share/doc/bless-0.3.6/user
	cd doc/user
	dohtml -r *
}
