# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Linux Audio Multiple Interface Player"
HOMEPAGE="http://lamip.sourceforge.net"
SRC_URI="http://fondriest.frederic.free.fr/realisations/lamip/files/src/${PV/_*/}/${P/_/}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/sources"

IUSE="debug curl a52 aac vorbis flac alsa oss gtk vqf musepack mad cdparanoia
	mod dts shorten jack speex wavpack readline"
DEPEND="curl ( >=net-misc/curl-7.10* )"
RDEPEND="${DEPEND}"
PDEPEND="media-plugins/lamip-in-playlist
	media-plugins/lamip-in-wav
	gtk? ( media-plugins/lamip-ui-default )
	readline? ( media-plugins/lamip-ui-shell )
	alsa? ( media-plugins/lamip-out-alsa )
	jack? ( media-plugins/lamip-out-jack )
	oss? (media-plugins/lamip-out-oss )
	a52? ( media-plugins/lamip-in-a52dec )
	aac? ( media-plugins/lamip-in-faad )
	cdparanoia? ( media-plugins/lamip-in-cdparanoia )
	flac? ( media-plugins/lamip-in-flac )
	mad? ( media-plugins/lamip-in-mad )
	musepack? ( media-plugins/lamip-in-musepack )
	vorbis? ( media-plugins/lamip-in-vorbis )
	vqf? ( media-plugins/lamip-in-vqf )
	mod? ( media-plugins/lamip-in-mod )
	dts? ( media-plugins/lamip-in-dts )
	shorten? ( media-plugins/lamip-in-shn )
	speex? ( media-plugins/lamip-in-speex )
	wavpack? ( media-plugins/lamip-in-wavpack )"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf || die "autotools failed"
}

src_compile() {
	econf \
		`use_enable curl network` \
		`use_enable debug` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog NEWS README
}

