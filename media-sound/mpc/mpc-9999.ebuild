# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpc/mpc-0.12.0_rc1.ebuild,v 1.1 2006/08/13 01:29:18 ticho Exp $

inherit subversion autotools bash-completion

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="http://www.musicpd.org"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"
ESVN_BOOTSTRAP="eautoreconf"
IUSE="bash-completion"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF} || die
	use bash-completion && dobashcompletion doc/mpc-bashrc
}
