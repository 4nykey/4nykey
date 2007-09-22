# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/traverso/traverso-0.41.0-r1.ebuild,v 1.2 2007/07/09 19:14:38 aballier Exp $

inherit cvs qt4 toolchain-funcs

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"
ECVS_SERVER="cvs.savannah.nongnu.org:/sources/traverso"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

IUSE="alsa jack lv2 opengl sse mad vorbis flac wavpack"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="
	$(qt4_min_version 4.2.3)
	>=dev-libs/glib-2.8
	>=media-libs/libsndfile-1.0.12
	media-libs/libsamplerate
	>=sci-libs/fftw-3
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	lv2? ( dev-libs/rasqal dev-libs/redland )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
"
RDEPEND="
	${DEPEND}
"
#	lv2? ( media-plugins/swh-lv2 )
DEPEND="
	${DEPEND}
	sys-apps/sed
"

pkg_setup() {
	if use opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for traverso requires qt4 to be built with opengl support"
	fi
}

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-*.diff
	#  Removing forced cxxflags
	sed -ie "s:^\(.*QMAKE_CXXFLAGS_RELEASE.*\):#\1:" src/base.pri
}

src_compile() {
	echo "DEFINES += STATIC_BUILD" >> src/base.pri
	use jack || echo "DEFINES -= JACK_SUPPORT" >> src/base.pri
	use alsa || echo "DEFINES -= ALSA_SUPPORT" >> src/base.pri
	use sse || echo "DEFINES -= SSE_OPTIMIZATIONS" >> src/base.pri
	use lv2 || echo "DEFINES -= LV2_SUPPORT" >> src/base.pri
	use opengl || echo "DEFINES -= QT_OPENGL_SUPPORT" >> src/base.pri

	eqmake4 traverso.pro -recursive -after \
		"target.path=/usr/bin" "DESTDIR_TARGET=/usr/bin" \
		"QMAKE_STRIP='/usr/bin/true'" \
		|| die "qmake failed"
	emake \
		CC=$(tc-getCC) CXX=$(tc-getCXX) LINK=$(tc-getCXX) \
		|| die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
if false; then
	dolib.so lib/*.so*
	insinto /usr/$(get_libdir)/commandplugins
	insopts -m0755
	doins lib/commandplugins/*.so
	insopts -m0644
fi
	insinto /usr/share/mime/packages
	newins resources/x-traverso.xml traverso.xml
	find resources/freedesktop/icons -type d -name CVS | xargs rm -rf
	insinto /usr/share/icons/hicolor
	doins -r resources/freedesktop/icons/*
	doicon resources/freedesktop/icons/128x128/apps/traverso.png
	domenu resources/traverso.desktop
	dodoc AUTHORS ChangeLog HISTORY README TODO resources/help.text
}
