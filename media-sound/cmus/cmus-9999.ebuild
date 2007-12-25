# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="CMus - ncurses based music player."
HOMEPAGE="http://cmus.sourceforge.net"
EGIT_REPO_URI="git://repo.or.cz/cmus.git"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE="
alsa arts flac oss mad modplug vorbis musepack ao unicode aac mp4
zsh-completion ffmpeg
"

RDEPEND="
	sys-libs/ncurses
	alsa? ( >=media-libs/alsa-lib-1.0.11 )
	arts? ( kde-base/arts )
	ao? ( media-libs/libao )
	flac? ( >=media-libs/flac-1.1.1 )
	mad? ( >=media-libs/libmad-0.14 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	musepack? ( media-libs/libmpcdec )
	aac? (
		media-libs/faad2
		mp4? ( media-libs/libmp4v2 )
	)
	ffmpeg? ( media-video/ffmpeg )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
"

pkg_setup() {
	if use unicode && ! built_with_use sys-libs/ncurses unicode
	then
		eerror "You need sys-libs/ncurses compiled with the unicode USE flag."
		die "need sys-libs/ncurses with unicode support"
	fi
}

teh_conf() {
	local arg="${2:-$1}"
	arg=$(echo config_${arg} | tr [:lower:] [:upper:])
	use $1 && arg="${arg}=y" || arg="${arg}=n"
	myconf="${myconf} ${arg}"
}

src_compile() {
	local myconf
	teh_conf flac
	teh_conf mad
	teh_conf modplug
	teh_conf musepack mpc
	teh_conf vorbis
	teh_conf alsa
	teh_conf ao
	teh_conf arts
	teh_conf oss
	teh_conf aac
	teh_conf mp4
	teh_conf ffmpeg

	./configure \
		prefix=/usr \
		${myconf} || die

	emake V=2 || die
}

src_install() {
	make DESTDIR=${D} install || die
	mv ${D}usr/share/doc/{${PN},${PF}}
	dodoc AUTHORS HACKING README
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/_cmus
	fi
}
