# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="CMus - ncurses based music player."
HOMEPAGE="http://cmus.sourceforge.net"
EGIT_REPO_URI="git://repo.or.cz/cmus.git"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="
alsa arts flac oss mad modplug vorbis musepack ao aac mp4
zsh-completion ffmpeg verbose-build
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

teh_conf() {
	[[ $1 = *-* ]] && return
	local arg="${2:-$1}"
	arg=$(echo config_${arg} | tr [:lower:] [:upper:])
	use $1 && arg="${arg}=y" || arg="${arg}=n"
	myconf="${myconf} ${arg}"
}

src_compile() {
	local myconf
	for x in ${IUSE}; do teh_conf ${x}; done
	teh_conf musepack mpc

	tc-export CC

	./configure \
		prefix=/usr \
		${myconf} || die

	use verbose-build && local _args="V=2"
	emake ${_args} || die
}

src_install() {
	make DESTDIR=${D} install || die
	mv ${D}usr/share/doc/{${PN},${PF}}
	dodoc AUTHORS README
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/_cmus
	fi
}
