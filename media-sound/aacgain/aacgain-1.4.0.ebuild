# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="AACGain is a modification to mp3gain, it supports AAC (mp4/m4a/QuickTime) in addtion to mp3"
HOMEPAGE="http://altosdesign.com/aacgain"
SRC_URI=""
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-libs/faad2-2*
	>=media-video/mpeg4ip-1.2.1*"
DEPEND="${RDEPEND}"

src_unpack() {
	# yup
	ECVS_SERVER="cvs.sourceforge.net:/cvsroot/mp3gain"
	ECVS_MODULE="aacgain" cvs_src_unpack
	ECVS_MODULE="mp3gain" cvs_src_unpack
	ECVS_SERVER="cvs.sourceforge.net:/cvsroot/mpeg4ip"
	ECVS_MODULE="mpeg4ip/lib/mp4v2" cvs_src_unpack
	ECVS_SERVER="cvs.sourceforge.net:/cvsroot/faac"
	ECVS_MODULE="faad2/libfaad" cvs_src_unpack
	# //yup
	cp ${FILESDIR}/Makefile ${S}
}

src_install(){
	dobin aacgain
	dodoc README
}
