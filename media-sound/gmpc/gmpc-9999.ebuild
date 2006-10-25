# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmpc/gmpc-0.12.0-r1.ebuild,v 1.5 2005/08/24 21:53:30 gustavoz Exp $

inherit subversion autotools

DESCRIPTION="A Gnome client for the Music Player Daemon."
HOMEPAGE="http://cms.qballcow.nl/index.php?page=Gnome_Music_Player_Client"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="gnome"

RDEPEND=">=x11-libs/gtk+-2.8
	=gnome-base/libglade-2*
	dev-libs/libxml2
	dev-perl/XML-Parser
	media-libs/libmpd
"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README doc/*.txt
}
