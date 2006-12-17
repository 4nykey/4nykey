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
IUSE="
vorbis flac sid python ruby alsa curl aac gnome jack mad oss samba modplug
speex musepack encode ape mms wma boost ecore avahi fam fftw
libsamplerate
"

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
	python? ( dev-lang/python )
	ruby? ( >=dev-lang/ruby-1.8 )
	boost? ( dev-libs/boost )
	ecore? ( x11-libs/ecore )
	avahi? ( net-dns/avahi )
	fam? ( app-admin/gamin )
	fftw? ( >=sci-libs/fftw-3 )
	libsamplerate? ( media-libs/libsamplerate )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	python? ( dev-python/pyrex )
	dev-lang/python
	dev-util/pkgconfig
"

pick_plug() {
	use $1 || myconf="${myconf} --without-plugins=${2:-$1}"
}

src_compile() {
	local myconf
	pick_plug alsa
	pick_plug curl
	pick_plug curl lastfm
	pick_plug aac faad
	pick_plug flac
	pick_plug gnome gnomevfs
	pick_plug jack
	pick_plug mad
	pick_plug modplug
	pick_plug oss
	pick_plug samba
	pick_plug sid
	pick_plug speex
	pick_plug vorbis
	pick_plug musepack
	pick_plug encode diskwrite
	pick_plug encode ices
	pick_plug ape mac
	pick_plug mms
	pick_plug wma
	if ! use fftw && ! use libsamplerate; then
		myconf="${myconf} --without-plugins=vocoder"
	fi

	export GIT_DIR="${EGIT_STORE_DIR}/${EGIT_PROJECT}/${EGIT_REPO_URI##*/}"

	WAF="./waf ${MAKEOPTS} --prefix=/usr --destdir=${D} ${myconf}"

	sed -i s:-O0:-O2: wscript
	${WAF} -j1 configure || die
	${WAF} build || die
}

src_install() {
	${WAF} install || die

	dodoc AUTHORS README TODO
}
