# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/snd/snd-7.15.ebuild,v 1.7 2006/01/27 22:10:38 ticho Exp $

inherit multilib cvs

DESCRIPTION="Snd is a sound editor"
HOMEPAGE="http://ccrma.stanford.edu/software/snd/"
ECVS_SERVER="${PN}.cvs.sourceforge.net:/cvsroot/${PN}"
ECVS_MODULE="cvs-snd"
S="${WORKDIR}/${ECVS_MODULE}"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86"
IUSE="
alsa esd fam fftw gsl gtk guile jack ladspa motif nls opengl ruby vorbis mp3
speex flac timidity shorten wavpack cairo postscript
"

DEPEND="
	media-libs/audiofile
	motif? ( x11-libs/openmotif )
	alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	fam? ( virtual/fam )
	fftw? ( sci-libs/fftw )
	gsl? ( >=sci-libs/gsl-0.8 )
	gtk? ( >=x11-libs/gtk+-2 )
	guile? ( >=dev-scheme/guile-1.3.4 )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/ladspa-sdk )
	nls? ( sys-devel/gettext )
	opengl? ( virtual/opengl )
	ruby? ( virtual/ruby )
	cairo? ( x11-libs/cairo )
"
RDEPEND="
	${DEPEND}
	vorbis? ( media-sound/vorbis-tools )
	mp3? ( virtual/mpg123 )
	speex? ( media-libs/speex )
	flac? ( media-libs/flac )
	timidity? ( media-sound/timidity++ )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack )
"

pkg_setup() {
	# few quotes from configure
	if ! use motif && ! use gtk && ! use guile && ! use ruby; then
		ewarn "snd needs either an extension language (Guile or Ruby),"
		ewarn "or a graphics toolkit (GTK or Motif), or preferably both."
		ewarn "As currently configured, this version of snd is useless."
	fi
	if use motif && use gtk; then
		ewarn "You asked for both Motif and GTK, Motif will be used."
	fi
	if use guile && use ruby; then
		ewarn "You asked for both Guile and Ruby, Guile will be used."
	fi
	if use alsa && use esd; then
		ewarn "ESD will be the default ao, as it takes precedence over ALSA,"
		ewarn "the two are not compatible."
	fi
}

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch "${FILESDIR}"/${PN}-*.diff
}

src_compile() {
	local myconf
	if use opengl; then
		if use guile; then
			myconf="${myconf} --with-gl"
		else
			myconf="${myconf} --with-just-gl"
		fi
		myconf="${myconf} $(use_with postscript gl2ps)"
	else
		myconf="${myconf} --without-gl"
	fi

	econf \
		$(use_with alsa) \
		$(use_with esd) \
		$(use_with jack) \
		$(use_with guile) \
		$(use_with ruby) \
		$(use_with ladspa) \
		$(use_with gtk) \
		$(use_with gtk static-xg) \
		$(use_with cairo) \
		$(use_with motif) \
		$(use_with motif static-xm) \
		$(use_with motif editres) \
		$(use_with fam) \
		$(use_with fftw) \
		$(use_with gsl) \
		$(use_enable nls) \
		--without-builtin-gtkrc \
		--disable-deprecated \
		--with-doc-dir=/usr/share/doc/${PF}/html \
		${myconf} || die

	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc README.Snd HISTORY.Snd TODO.Snd Snd.ad
	dohtml -r .
}
