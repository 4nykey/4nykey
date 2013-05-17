# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sweep/sweep-0.8.3.ebuild,v 1.9 2005/12/26 14:16:50 lu_zero Exp $

EAPI="4"

inherit subversion autotools-utils

DESCRIPTION="audio editor and live playback tool"
HOMEPAGE="http://www.metadecks.org/software/sweep/"
ESVN_REPO_URI="http://svn.metadecks.org/sweep/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa nls vorbis mad speex libsamplerate ladspa pulseaudio oss"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
PATCHES=("${FILESDIR}"/${PN}*.diff)

DEPEND="
	libsamplerate? ( media-libs/libsamplerate )
	>=media-libs/libsndfile-1.0
	speex? ( media-libs/libogg media-libs/speex )
	mad? ( >=media-sound/madplay-0.14.2b )
	>=x11-libs/gtk+-2.2.0
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	vorbis? ( media-libs/libvorbis )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.10 )
"
RDEPEND="
	${DEPEND}
	ladspa? ( media-libs/ladspa-cmt )
"
DEPEND="
	${DEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() {
	sed -e 's:AM_PROG_CC_STDC:AC_PROG_CC:' -i configure.ac
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-experimental
		$(use_enable pulseaudio)
		$(use_enable alsa)
		$(use_enable oss)
		$(use_enable nls)
		$(use_enable vorbis oggvorbis)
		$(use_enable speex)
		$(use_enable mad)
		$(use_enable libsamplerate src)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install \
		MKINSTALLDIRS="${S}"/mkinstalldirs
}
