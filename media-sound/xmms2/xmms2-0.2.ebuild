# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="XMMS2 is a redesign of the XMMS music player"
HOMEPAGE="http://xmms2.xmms.org/"
SRC_URI=""
EGIT_PROJECT="xmms2-devel"
EGIT_REPO_URI="rsync://git.xmms.se/xmms2/${EGIT_PROJECT}.git/"
#EPATCH_OPTS="-p1 --no-backup-if-mismatch"
#EGIT_PATCHES="*.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="vorbis flac sid python ruby alsa curl aac gnome jack mad oss samba mikmod speex sdl musepack"

RDEPEND=">=dev-libs/glib-2.2.0
	mad? ( media-libs/libmad )
	=dev-db/sqlite-3*
	curl? ( >=net-misc/curl-7.11.2 )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	aac? ( media-libs/faad2 )
	jack? ( media-sound/jack-audio-connection-kit )
	samba? ( net-fs/samba )
	mikmod? ( media-libs/libmodplug )
	speex? ( media-libs/speex )
	sid? ( media-libs/libsidplay )
	musepack? ( media-libs/libmpcdec )
	sdl? ( media-libs/sdl-ttf )
	python? ( dev-python/pyrex )
	ruby? ( >=dev-lang/ruby-1.8 )"
DEPEND="${RDEPEND}
	dev-util/scons"

pick_plug() {
	use $1 || myconf="${myconf} $( [ -n "$2" ] && echo $2 || echo $1)"
}

src_compile() {
	local myconf
	pick_plug alsa
	pick_plug curl curl_http
	pick_plug aac faad
	pick_plug flac
	pick_plug gnome gnomevfs
	pick_plug jack
	pick_plug mad
	pick_plug mikmod modplug
	pick_plug oss
	pick_plug samba smb
	pick_plug sid
	pick_plug sdl sdl-vis
	pick_plug speex
	pick_plug vorbis vorbisfile
	pick_plug musepack

	scons \
		INSTALLDIR="${D}" PREFIX="/usr" ${MAKEOPTS} SYSCONFDIR="/etc" \
		EXCLUDE="${myconf}" CCFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	scons \
		CONFIG=0 INSTALLDIR=${D} PREFIX="/usr" ${MAKEOPTS} SYSCONFDIR="/etc" \
		install || die

#	if ! id xmms2 >& /dev/null; then
#		enewgroup audio
#		enewuser xmms2 -1 -1 /home/xmms2 audio
#	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/xmms2-initscript-gentoo xmms2d
	insinto /etc/conf.d
	newins ${FILESDIR}/xmms2-initscript-gentoo.conf xmms2d
	dodoc AUTHORS ChangeLog README TODO
}
