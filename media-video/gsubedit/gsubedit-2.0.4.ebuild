# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gsubedit/gsubedit-0.4_pre1-r1.ebuild,v 1.4 2004/11/12 16:30:11 blubb Exp $

inherit cvs gnome2

DESCRIPTION="Gnome Subtitle Editor"
HOMEPAGE="http://gsubedit.sourceforge.net"
SRC_URI=""
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/gsubedit"
ECVS_MODULE="gsubedit-2"
S="${WORKDIR}/${ECVS_MODULE}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-*"
IUSE="nls"

G2CONF="`use_with nls`"
DOCS="AUTHORS ChangeLog TODO"

DEPEND=">=x11-libs/gtk+-2.4.0
		=gnome-base/libgnomeui-2*"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	echo -e \
		'm4_pattern_allow(PKG_LIBS)\nm4_pattern_allow(PKG_CFLAGS)\nm4_pattern_allow(PKG_PKG_ERRORS)' > \
		acinclude.m4
	sed -i /^CFLAGS/d configure.ac
	#eautoreconf
	einfo "Running autogen.sh"
	NOCONFIGURE=y ./autogen.sh >& /dev/null || die "autogen.sh failed" 
}

src_install() {
	gnome2_src_install
	make_desktop_entry gsubedit GSubEdit gsubedit
}
