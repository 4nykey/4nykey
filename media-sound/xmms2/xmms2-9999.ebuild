# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="XMMS2 is a redesign of the XMMS music player"
HOMEPAGE="http://xmms2.xmms.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.xmms.se/xmms2/xmms2-devel.git/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="vorbis flac sid python ruby alsa curl aac gnome jack mad oss samba modplug
speex sdl musepack encode ape mms wma java boost ecore avahi fam"

RDEPEND="
	>=dev-libs/glib-2.2.0
	mad? ( media-libs/libmad )
	=dev-db/sqlite-3*
	curl? ( >=net-misc/curl-7.11.2 )
	vorbis? ( media-libs/libvorbis )
	encode? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	aac? ( media-libs/faad2 )
	jack? ( media-sound/jack-audio-connection-kit )
	samba? ( net-fs/samba )
	gnome? ( =gnome-base/gnome-vfs-2* )
	modplug? ( media-libs/libmodplug )
	speex? ( media-libs/speex )
	sid? ( media-libs/libsidplay )
	musepack? ( media-libs/libmpcdec )
	ape? ( media-sound/mac )
	mms? ( media-libs/libmms )
	wma? ( media-video/ffmpeg )
	sdl? ( media-libs/sdl-ttf )
	python? ( dev-python/pyrex )
	ruby? ( >=dev-lang/ruby-1.8 )
	java? ( >=dev-lang/swig-1.3.25 virtual/jdk )
	boost? ( dev-libs/boost )
	ecore? ( x11-libs/ecore )
	avahi? ( net-dns/avahi )
	fam? ( app-admin/gamin )
	oss? ( virtual/os-headers )
"
DEPEND="
	${RDEPEND}
	dev-util/scons
"

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
	pick_plug modplug
	pick_plug oss
	pick_plug samba smb
	pick_plug sid
	pick_plug sdl sdl-vis
	pick_plug speex
	pick_plug vorbis vorbisfile
	pick_plug musepack
	pick_plug encode diskwrite
	pick_plug encode ices
	pick_plug ape mac
	pick_plug mms
	pick_plug wma
	pick_plug java
	pick_plug boost xmmsclient++
	pick_plug ecore xmmsclient-ecore
	pick_plug avahi xmms2-mdns-avahi
	pick_plug fam xmms2-mlib-updater

	scons \
		INSTALLDIR=${D} \
		PREFIX="/usr" \
		SYSCONFDIR="/etc" \
		EXCLUDE="${myconf}" \
		CCFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		${MAKEOPTS} || die
}

src_install() {
	scons \
		CONFIG=0 \
		INSTALLDIR=${D} \
		PREFIX="/usr" \
		SYSCONFDIR="/etc" \
		${MAKEOPTS} \
		install || die

	if false; then
	exeinto /etc/init.d
	newexe ${FILESDIR}/xmms2-initscript-gentoo xmms2d
	insinto /etc/conf.d
	newins ${FILESDIR}/xmms2-initscript-gentoo.conf xmms2d
	fi
	dodoc AUTHORS ChangeLog README TODO
}
