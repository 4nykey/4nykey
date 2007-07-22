# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

AT_M4DIR="m4"
DESCRIPTION="Frame Server for Linux and Windows"
HOMEPAGE="http://avisynth2.sourceforge.net"
ESVN_REPO_URI="https://avisynth2.svn.sourceforge.net/svnroot/avisynth2/Avisynth3/trunk/avisynth"
ESVN_PATCHES="${PN}-*.diff ${S}/build/linux/gentoo/files/*.patch"
ESVN_BOOTSTRAP="cd build/linux && eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug doc gtk ffmpeg"

DEPEND="
	dev-libs/STLport
	>=dev-libs/boost-1.34
	>=media-libs/freetype-2
	media-libs/fontconfig
	x86? ( dev-lang/nasm )
	>=media-libs/gst-plugins-base-0.10.8
	gtk? ( >=x11-libs/gtk+-2.8 )
"
RDEPEND="
	${DEPEND}
	ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10 )
"
DEPEND="
	${DEPEND}
	doc? ( app-doc/doxygen )
"

src_unpack() {
	subversion_src_unpack
	tar -xjf ${S}/build/circular_buffer_v3.7.tar.bz2
	mv circular_buffer boost
}

src_compile() {
	cd build/linux

	CPPFLAGS="${CPPFLAGS} -I." \
	econf \
		$(use_enable debug core-debug) \
		$(use_enable gtk gui) \
		$(use_enable doc) \
		--with-boost-lib-name=boost_thread-mt \
		|| die

	make || die
}

src_install() {
	make DESTDIR=${D} -C build/linux install || die
	dodoc Changelog.txt TODO
}
