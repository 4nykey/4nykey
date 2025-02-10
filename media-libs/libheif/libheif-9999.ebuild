# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils cmake-multilib

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	SRC_URI=""
	inherit git-r3
	SLOT="0/${PV}"
else
	MY_PV="v$(ver_rs 3 -)"
	SRC_URI="
		mirror://githubcl/strukturag/libheif/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
	KEYWORDS="~amd64"
	SLOT="0/$(ver_cut 1-2)"
fi

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
IUSE="+aom gdk-pixbuf go rav1e svt-av1 test +threads x265"
IUSE+=" +brotli ffmpeg openh264 openjph uvg266 vvdec vvenc webp"
REQUIRED_USE="test? ( go )"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

BDEPEND="
	test? (
		dev-lang/go
	)
"
DEPEND="
	media-libs/dav1d:=[${MULTILIB_USEDEP}]
	media-libs/libde265:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	media-libs/tiff:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-2.0.0:=[${MULTILIB_USEDEP}] )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}] )
	go? ( dev-lang/go )
	rav1e? ( media-video/rav1e:= )
	svt-av1? ( media-libs/svt-av1:=[${MULTILIB_USEDEP}] )
	x265? ( media-libs/x265:=[${MULTILIB_USEDEP}] )
	brotli? ( app-arch/brotli:=[${MULTILIB_USEDEP}] )
	ffmpeg? ( media-video/ffmpeg:=[${MULTILIB_USEDEP}] )
	openh264? ( media-libs/openh264:=[${MULTILIB_USEDEP}] )
	openjph? ( media-libs/openjph:=[${MULTILIB_USEDEP}] )
	uvg266? ( media-libs/uvg266[${MULTILIB_USEDEP}] )
	vvenc? ( media-libs/vvenc:=[${MULTILIB_USEDEP}] )
	vvdec? ( media-libs/vvdec:=[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	media-libs/openjpeg:=[${MULTILIB_USEDEP}]
	media-libs/kvazaar:=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libheif/heif_version.h
)
PATCHES=( ${FILESDIR}/cmake.diff )

src_prepare() {
	sed -e '/Werror/d' -i CMakeLists.txt || die # bug 936466

	cmake_src_prepare

	multilib_copy_sources
}

multilib_src_configure() {
	export GO111MODULE=auto
	local mycmakeargs=(
		-DENABLE_PLUGIN_LOADING=true
		-DWITH_LIBDE265=true
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_AOM_ENCODER=$(usex aom)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_RAV1E="$(multilib_native_usex rav1e)"
		-DWITH_SvtEnc="$(usex svt-av1)"
		-DWITH_X265=$(usex x265)
		-DWITH_KVAZAAR=true
		-DWITH_JPEG_DECODER=true
		-DWITH_JPEG_ENCODER=true
		-DWITH_OpenJPEG_DECODER=true
		-DWITH_OpenJPEG_ENCODER=true
	)
	mycmakeargs+=(
		-DWITH_REDUCED_VISIBILITY=$(usex threads)
		-DWITH_DAV1D=true
		-DWITH_LIBSHARPYUV=$(usex webp)
		-DWITH_UNCOMPRESSED_CODEC=$(usex brotli)
		-DWITH_FFMPEG_DECODER=$(usex ffmpeg)
		-DWITH_OpenH264_DECODER=$(usex openh264)
		-DWITH_OpenH264_ENCODER=$(usex openh264)
		-DWITH_OPENJPH_DECODER=$(usex openjph)
		-DWITH_OPENJPH_ENCODER=$(usex openjph)
		-DWITH_UVG266=$(usex uvg266)
		-DWITH_VVENC=$(usex vvenc)
		-DWITH_VVDEC=$(usex vvdec)
	)
	cmake_src_configure
}

pkg_preinst() {
	multilib_foreach_abi gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	multilib_foreach_abi gnome2_gdk_pixbuf_update
}
