# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-1.2.3-r1.ebuild,v 1.1 2005/04/15 17:46:25 luckyduck Exp $

inherit cvs wxwidgets eutils

IUSE="gtk2 encode flac mad vorbis libsamplerate alsa ladspa"

#MY_PV="${PV/_/-}"
#MY_P="${PN}-src-${MY_PV}"
S="${WORKDIR}/${PN}"

DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://audacity.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/audacity"
ECVS_MODULE="audacity"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

DEPEND=">=x11-libs/wxGTK-2.4.2-r1
	>=app-arch/zip-2.3
	>=media-libs/id3lib-3.8.0
	media-libs/libid3tag
	>=media-libs/libsndfile-1.0.0
	libsamplerate? ( >=media-libs/libsamplerate-0.0.14 )
	>=media-libs/ladspa-sdk-1.12
	flac? ( media-libs/flac )
	oggvorbis? ( >=media-libs/libvorbis-1.0 )
	mad? ( media-libs/libmad )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/ladspa-sdk )
	encode? ( >=media-sound/lame-3.92 )"

pkg_setup() {
	if has_version '>=x11-libs/wxGTK-2.6.0'; then
		WX_GTK_VER="2.6"
	fi

	if use gtk2; then
		need-wxwidgets gtk2
	else
		need-wxwidgets gtk
	fi
}

src_unpack() {
	cvs_src_unpack
	cd ${S}
	sed -i 's:0\.15\.0:0.1.2:g' configure

	if use alsa || use jack ; then
#		ECVS_SERVER="www.portaudio.com:/home/cvs"
#		ECVS_MODULE="portaudio"
#		ECVS_BRANCH="v19-devel"
#		cvs_src_unpack
		cd ${S}/lib-src/portaudio-v19
		WANT_AUTOCONF=2.5 autoconf --force
	fi
}

src_compile() {
#	if use alsa; then
#		cd ${WORKDIR}/portaudio
#		econf --with-alsa || die
#		make lib/libportaudio.a || die
#	fi

	if use libsamplerate; then
		myconf="${myconf} --with-libsamplerate=system"
	else
		myconf="${myconf} --without-libsamplerate"
	fi
	use ladspa && LADSPA="yes" || LADSPA="no"
	if use alsa || use jack; then
		PA_VERSION="=v19"
		PMIXER="no"
	else
		PA_VERSION="=v18"
		PMIXER="yes"
	fi

	ac_cv_path_WX_CONFIG=${WX_CONFIG} \
	econf \
		--with-nyquist=local \
		--with-lib-preference=system \
		--with-ladspa=${LADSPA} \
		--with-portmixer=${PMIXER} \
		--with-portaudio${PA_VERSION} \
		${myconf} || die

	# parallel borks
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die

	# Install our docs
	dodoc LICENSE.txt README.txt audacity-1.2-help.htb

	# Remove bad doc install
	rm -rf ${D}/share/doc

	insinto /usr/share/icons/hicolor/48x48/apps
	newins images/AudacityLogo48x48.xpm audacity.xpm

	make_desktop_entry audacity Audacity audacity
}
