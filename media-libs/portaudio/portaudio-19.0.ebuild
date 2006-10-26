# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/portaudio/portaudio-18.1-r4.ebuild,v 1.3 2006/04/16 22:28:10 hansmi Exp $

inherit subversion

DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
ESVN_REPO_URI="https://www.portaudio.com/repos/portaudio/branches/v19-devel"

LICENSE="GPL-2"
SLOT="19"
KEYWORDS="~x86"
IUSE="jack alsa oss doc"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	sed -i "s: tests::" Makefile.in
	# make it slot-friendly
	sed -i "s:\(PALIB = libportaudio\)\.la:\1-19.la:" Makefile.in
	sed -i "s:\(-lportaudio\) :\1-19 :" portaudio-2.0.pc.in
}

src_compile() {
	econf \
		--includedir=/usr/include/portaudio19 \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with jack) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	if use doc; then
		dodoc docs/*.txt
		dohtml docs/*.html
	fi
	rm ${D}/usr/lib/libportaudio.so
}
