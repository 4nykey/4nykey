# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Avidemux plugins"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
EGIT_REPO_URI="git://gitorious.org/avidemux2-6/avidemux2-6.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="
	cli gtk qt4 xvid x264 javascript a52 twolame lame dts aac vorbis amr vpx
	alsa jack libsamplerate oss pulseaudio nls opengl truetype bidi fontconfig
	vdpau
"

RDEPEND="
	~media-video/avidemux-core-${PV}:${SLOT}[vdpau=]
	cli? ( ~media-video/avidemux-cli-${PV}:${SLOT} )
	gtk? ( ~media-video/avidemux-gtk-${PV}:${SLOT} )
	qt4? ( ~media-video/avidemux-qt4-${PV}:${SLOT}[opengl=] )

	x264? ( media-libs/x264 )
	xvid? ( media-libs/xvid )

	javascript? ( dev-lang/spidermonkey )

	a52? ( media-libs/aften )
	twolame? ( media-sound/twolame )
	lame? ( media-sound/lame )
	dts? ( media-libs/libdca media-sound/dcaenc )
	aac? ( media-libs/faad2 media-libs/faac )
	vorbis? ( media-libs/libvorbis )
	amr? ( media-libs/opencore-amr )
	vpx? ( media-libs/libvpx )

	alsa? ( media-libs/alsa-lib )
	jack? (
		media-sound/jack-audio-connection-kit
		libsamplerate? ( media-libs/libsamplerate )
	)
	pulseaudio? ( media-sound/pulseaudio )

	truetype? ( media-libs/freetype:2 )
	bidi? ( dev-libs/fribidi )
	fontconfig? ( media-libs/fontconfig )
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

CMAKE_USE_DIR="${S}"/avidemux_plugins

domea() { 
	if [[ ${UI} == "ALL" ]]; then
		cmake-utils_src_${1}
	else
		local d
		for d in ${UI}; do
			CMAKE_BUILD_DIR="${S}"/${d} \
				cmake-utils_src_${1}
		done
	fi
}

src_configure() { 
	local x mycmakeargs
	mycmakeargs="
		-DAVIDEMUX_SOURCE_DIR=${S}
		$(for x in ${IUSE}; do cmake-utils_use $x; done)
		$(cmake-utils_use		javascript SPIDERMONKEY)
		$(cmake-utils_use		a52 AFTEN)
		$(cmake-utils_use		dts LIBDCA)
		$(cmake-utils_use		dts DCAENC)
		$(cmake-utils_use		aac FAAC)
		$(cmake-utils_use_use	aac FAAD)
		$(cmake-utils_use		amr OPENCORE_AMRWB)
		$(cmake-utils_use		amr OPENCORE_AMRNB)
		$(cmake-utils_use vpx	VPXDEC)
		$(cmake-utils_use_use	vpx)
		$(cmake-utils_use_use	alsa)
		$(cmake-utils_use_use	jack)
		$(cmake-utils_use_use	libsamplerate SRC)
		$(cmake-utils_use_use	oss)
		$(cmake-utils_use_use	pulseaudio PULSEAUDIOSIMPLE)
		$(cmake-utils_use_use	truetype FREETYPE)
		$(cmake-utils_use_use	bidi FRIBIDI)
		$(cmake-utils_use_use	fontconfig)
	"
	if use cli && use gtk && use qt4; then
		UI="ALL"
		mycmakeargs="${mycmakeargs} -DPLUGIN_UI=ALL" \
			cmake-utils_src_configure
	else
		UI="COMMON"
		use cli && UI+=" CLI"
		use gtk && UI+=" GTK"
		use qt4 && UI+=" QT4"
		local d
		for d in ${UI}; do
			mycmakeargs="${mycmakeargs} -DPLUGIN_UI=${d}" \
			CMAKE_BUILD_DIR="${S}"/${d} \
				cmake-utils_src_configure
		done
	fi
}

src_compile() { 
	domea compile
}

src_install() { 
	domea install
}
