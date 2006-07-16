# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="DVD-Audio Tools"
HOMEPAGE="http://dvd-audio.sourceforge.net/"
SRC_URI=""
ECVS_SERVER="dvd-audio.cvs.sourceforge.net:/cvsroot/dvd-audio"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/flac
	media-libs/libdvdread"
RDEPEND="${DEPEND}"

src_unpack() {
	ECVS_MODULE="dvda-author" \
		cvs_src_unpack
	ECVS_MODULE="tools" \
		cvs_src_unpack
	EPATCH_OPTS="-d ${S}/dvda-author ${EPATCH_OPTS}" \
		epatch ${FILESDIR}/dvda-author-*.diff
	EPATCH_OPTS="-d ${S}/tools ${EPATCH_OPTS}" \
		epatch ${FILESDIR}/tools-*.diff
}

src_compile() {
	emake -C dvda-author/src || die
	emake -C tools || die
}

src_install() {
	dobin dvda-author/src/dvda-author
	dobin tools/{ats2wav,dump_aob,dump_atsi,dump_audio_pp,vts2wav,wav2lpcm}
	dodoc dvda-author/{CHANGES,README,sort.txt}
}
