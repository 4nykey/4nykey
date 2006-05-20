# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""
ECVS_SERVER="avisynth2.cvs.sourceforge.net:/cvsroot/avisynth2"
ECVS_MODULE="${PN}"
ECVS_BRANCH="avisynth_3_0"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug gstreamer gtk ffmpeg"

RDEPEND="dev-libs/STLport
	>=dev-libs/boost-1.33.0
	media-libs/freetype
	x86? ( dev-lang/nasm )
	gstreamer? ( >=media-libs/gst-plugins-0.8.11
		ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.8.7 ) )
	gtk? ( >=x11-libs/gtk+-2.4.0 )"
DEPEND="${RDEPEND}"

pkg_setup() {
	if ! built_with_use -o dev-libs/boost threads threadsonly; then
		eerror "Please emerge dev-libs/boost with either 'threads' or"
		eerror "'threadsonly' USE-flags"
		die "This package needs multi-threaded dev-libs/boost"
	fi
}

src_unpack() {
	cvs_src_unpack
	cd ${S}
	# missing DEST_DIR in install rules
	epatch ${FILESDIR}/${PN}-makefile.diff
	# fix stlport lib name
	epatch ${FILESDIR}/${PN}-stllib.diff
	# fix boost lib/inc paths, handle circular_buffer headers
	epatch ${FILESDIR}/${PN}-boost.diff
	cd build/linux
	# this would add "-fvisibility=hidden" to CFLAGS, which breaks linking
	sed -i '/AC_CHECK_GCC_VISIBILITY/d' configure.in
	sed -i 's:@VISIBILITY_[^@]*@::' platform.inc.in
	# needed headers
	tar -xjf ../circular_buffer_v3.7.tar.bz2
	AT_M4DIR=m4 eautoreconf || die
}

src_compile() {
	cd build/linux
	econf \
		`use_enable debug core-debug` \
		`use_enable x86 assembly` \
		--with-stl-path=/usr \
		--with-boost-path=/usr
	make || die
}

src_install() {
	make -C build/linux DEST_DIR=${D} install || die
	dodoc *.txt TODO docs/README
	dohtml docs/html/*.html
}
