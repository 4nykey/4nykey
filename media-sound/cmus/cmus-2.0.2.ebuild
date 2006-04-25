# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CMus - ncurses based music player."
SRC_URI="http://onion.dynserv.net/~timo/files/${P}.tar.bz2"
HOMEPAGE="http://onion.dynserv.net/~timo/?page=Projects/cmus"
SLOT="0"
IUSE="alsa arts debug flac oss mad modplug vorbis musepack ao"

DEPEND="sys-libs/ncurses
	alsa? ( >=media-libs/alsa-lib-0.9.0 )
	arts? ( kde-base/arts )
	ao? ( media-libs/libao )
	flac? ( >=media-libs/flac-1.1.1 )
	mad? ( >=media-libs/libmad-0.14 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	musepack? ( media-libs/libmpcdec )
	"

RDEPEND=${DEPEND}

LICENSE="GPL-2"
KEYWORDS="~x86"

pkg_setup()
{
	if ! built_with_use sys-libs/ncurses unicode
	then
		eerror "You need sys-libs/ncurses compiled with the unicode USE flag."
		die "need sys-libs/ncurses with unicode support"
	fi
}

src_compile()
{
	local debuglevel

	if use debug
	then
		debuglevel=2
	else
		debuglevel=0
	fi
	./configure \
		--prefix=/usr \
		`use_enable alsa` \
		`use_enable arts` \
		`use_enable ao` \
		`use_enable flac` \
		`use_enable oss` \
		`use_enable mad` \
		`use_enable modplug` \
		`use_enable vorbis` \
		`use_enable musepack mpc` \
		--debug=$debuglevel \
		|| die
	emake || die
}

src_install()
{
	make DESTDIR=${D} install || die
	dodoc AUTHORS HACKING README
}
