# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-1.2.3-r1.ebuild,v 1.1 2005/04/15 17:46:25 luckyduck Exp $

inherit cvs wxwidgets eutils

IUSE="encode flac mad vorbis libsamplerate alsa ladspa soundtouch unicode"

DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://audacity.sourceforge.net/"
ECVS_SERVER="audacity.cvs.sourceforge.net:/cvsroot/audacity"
ECVS_MODULE="audacity"

S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

RDEPEND=">=x11-libs/wxGTK-2.6.0
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
	alsa? ( media-libs/alsa-lib )
	ladspa? ( media-libs/ladspa-sdk )
	soundtouch? ( media-libs/libsoundtouch )
	encode? ( >=media-sound/lame-3.92 )"
DEPEND="${RDEPEND} 
	>=sys-devel/autoconf-2.5"

pkg_setup() {
	WX_GTK_VER="2.6"
	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi
}

src_unpack() {
	cvs_src_unpack
	cd ${S}
	sed -i 's:0\.15\.0:0.1.2:g' configure

	epatch "${FILESDIR}/audacity-1.3.1-cvs.diff"

	if use alsa || use jack ; then
		cd ${S}/lib-src/portaudio-v19
		WANT_AUTOCONF=2.5 autoconf --force
	fi
}

src_compile() {
	if use libsamplerate; then
		myconf="${myconf} --with-libsamplerate=system"
	else
		myconf="${myconf} --without-libsamplerate"
	fi
	if use soundtouch; then
		myconf="${myconf}  --with-soundtouch=local"
	else
		myconf="${myconf} --without-soundtouch"
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

	# parallel b0rks
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die

	# Install our docs
	dodoc LICENSE.txt README.txt audacity-1.2-help.htb

	# Remove bad doc install
	rm -rf ${D}/share/doc

	insinto /usr/share/pixmaps
	newins images/AudacityLogo48x48.xpm audacity.xpm
	dosed \
		'/^Name\[/d; s:^Icon=.*:Icon=audacity:; s:.*\(Desktop Entry\).*:[\1]:' \
		/usr/share/applications/audacity.desktop
}
