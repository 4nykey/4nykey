# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.3.0.ebuild,v 1.1 2005/08/27 20:35:31 rphillips Exp $

inherit subversion

DESCRIPTION="a better cd encoder"
HOMEPAGE="http://www.hispalinux.es/~data/abcde.php"
#SRC_URI="http://www.hispalinux.es/~data/files/${PN}_${PV}.orig.tar.gz"
ESVN_REPO_URI="https://svn.hispalinux.es:8081/svn/abcde/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="id3 mp3 flac vorbis musepack musicbrainz"

DEPEND="id3? ( >=media-sound/id3-0.12
		media-sound/id3v2 )
	>=media-sound/cd-discid-0.6
	>=media-sound/cdparanoia-3.9.7
	vorbis? ( >=media-sound/vorbis-tools-1.0_rc3 )
	flac? ( >=media-libs/flac-1 )
	mp3? ( media-sound/lame )
	musepack? ( media-sound/musepack-tools )
	musicbrainz? ( dev-python/python-musicbrainz )
	>=media-sound/normalize-0.7.4"

src_unpack() {
	subversion_src_unpack
	sed -i 's:/etc/abcde.conf:/etc/abcde/abcde.conf:g' ${S}/abcde
	sed -i 's:/etc:/etc/abcde/:g' ${S}/Makefile
}

src_install() {
	dodir /etc/abcde
	make DESTDIR=${D} install || die "make install failed"
	insinto /usr/bin
	insopts -m755
	doins examples/autorip.sh examples/cue2discid
	use musicbrainz && doins examples/musicbrainz-get-tracks
	dodoc FAQ KNOWN.BUGS README TODO USEPIPES changelog examples/abcde*
}
