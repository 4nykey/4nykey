# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="XMMS2 is a redesign of the XMMS music player"
HOMEPAGE="http://xmms2.xmms.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.xmms.se/xmms2/xmms2-devel.git"
EGIT_PATCHES="${PN}-*.diff"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
vorbis flac sid python ruby alsa curl aac gnome jack mad oss samba modplug speex
musepack encode ape mms ffmpeg boost avahi fam fftw libsamplerate perl cdda xml
ofa
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
	ffmpeg? ( media-video/ffmpeg )
	python? ( dev-lang/python )
	ruby? ( >=dev-lang/ruby-1.8 )
	boost? ( dev-libs/boost )
	avahi? ( net-dns/avahi )
	fam? ( app-admin/gamin )
	fftw? ( >=sci-libs/fftw-3 )
	libsamplerate? ( media-libs/libsamplerate )
	perl? ( dev-lang/perl )
	avahi? ( net-dns/avahi )
	cdda? ( dev-libs/libcdio )
	xml? ( dev-libs/libxml2 )
	ofa? ( media-libs/libofa )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	python? ( dev-python/pyrex )
	dev-lang/python
	dev-util/pkgconfig
"

pick_plug() {
	if [[ $1 == "-o" ]]; then
		pickwhat="optional"
		shift
	fi
	use $1 || myconf="${myconf} --without-${pickwhat:-plugin}s=${2:-$1}"
}

src_compile() {
	local myconf
	pick_plug alsa
	pick_plug curl
	pick_plug curl lastfm
	pick_plug curl lastfmeta
	use curl && pick_plug avahi daap
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
	pick_plug ffmpeg avformat
	pick_plug ffmpeg avcodec
	use fftw && pick_plug libsamplerate vocoder
	pick_plug cdda
	pick_plug xml
	pick_plug xml rss
	pick_plug xml xspf
	pick_plug ofa
	pick_plug -o boost xmmsclient++
	pick_plug -o python
	pick_plug -o perl
	pick_plug -o ruby
	pick_plug -o avahi
	pick_plug -o fam medialib-updater

	export GIT_DIR="${EGIT_STORE_DIR}/${EGIT_PROJECT}"

	WAF="./waf ${MAKEOPTS} --prefix=/usr --destdir=${D} ${myconf}"

	${WAF} -j1 configure || die
	${WAF} build || die
}

src_install() {
	${WAF} install || die

	dodoc AUTHORS COPYING README TODO
}
