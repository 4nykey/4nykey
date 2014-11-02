# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PLOCALES="
ach af am an ar ast az be bg bn bn_IN br bs ca cgg ckb co cs cy da de el en_GB
es et eu fa ff fi fr fur ga gd gl gu he hi hr hu hy ia id is it ja ka kk km kn
ko ky lg lt lv mk ml mn mr ms my nb ne nl nn oc or pa pl ps pt_BR pt_PT ro ru
si sk sl sq sr sv ta te tet th tl tr uk uz vi wa zh_CN zh_TW zu
"

PYTHON_COMPAT=( python2_7 )

inherit unpacker eutils l10n fdo-mime gnome2-utils nsplugins python-single-r1

MY_PV="${PV%.*}-1trusty${PV##*.}"
MY_PN="${PN%-*}"
DESCRIPTION="Ace Stream multimedia player based on VLC"
HOMEPAGE="http://torrentstream.org"
BASE_URI="http://repo.acestream.org/ubuntu/pool/main/a"
SRC_URI="
amd64? (
	${BASE_URI}/${MY_PN}/${MY_PN}_${MY_PV}_amd64.deb
	${BASE_URI}/${MY_PN}-data/${MY_PN}-data_${MY_PV}_amd64.deb
	nsplugin? (
		${BASE_URI}/${MY_PN%-*}-mozilla-plugin/${MY_PN%-*}-mozilla-plugin_${MY_PV}_amd64.deb
	)
)
x86? (
	${BASE_URI}/${MY_PN}/${MY_PN}_${MY_PV}_i386.deb
	${BASE_URI}/${MY_PN}-data/${MY_PN}-data_${MY_PV}_i386.deb
	nsplugin? (
		${BASE_URI}/${MY_PN%-*}-mozilla-plugin/${MY_PN%-*}-mozilla-plugin_${MY_PV}_i386.deb
	)
)
"
RESTRICT="primaryuri strip"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nsplugin"
S="${WORKDIR}/usr"

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND="
	nsplugin? ( dev-qt/qtwebkit:4 )
	net-p2p/acestream-engine
	dev-db/sqlite:3
    dev-lang/lua:5.2
    dev-libs/fribidi
    dev-libs/libebml
    dev-libs/libgcrypt:11
    dev-libs/libgpg-error
    dev-libs/libxml2
    dev-qt/qtdeclarative:4
    dev-qt/qtsql:4
    media-libs/alsa-lib
    media-libs/faad2
    media-libs/flac
    media-libs/fontconfig
    media-libs/freetype:2
    media-libs/libcaca
    media-libs/libdca
    media-libs/libdvdnav
    media-libs/libdvdread
    media-libs/libmad
    media-libs/libmatroska
    media-libs/libmodplug
    media-libs/libmpeg2
    media-libs/libogg
    media-libs/libpng:1.2
    media-libs/libsdl
    media-libs/libshout
    media-libs/libtheora
    media-libs/libvorbis
    media-libs/mesa
    media-libs/schroedinger
    media-libs/sdl-image
    media-libs/speex
    media-libs/taglib
    media-libs/x264
    media-sound/pulseaudio
    media-sound/twolame
    media-video/dirac
	=media-video/ffmpeg-1.2*
    net-dns/avahi
    sys-apps/dbus
    x11-libs/libva
    x11-libs/libxcb
"

rm_loc() {
	rm -rf share/locale/${1}
}

MY_PN="acestreamplayer"

src_prepare() {
	sed \
		-e 's:^Name=.*:& (binary):' \
		-e "s:${MY_PN}:${PN}:" \
		-e 's:\(Version=1\.0\)\..:\1:' \
		-i share/applications/${MY_PN}.desktop
	l10n_for_each_disabled_locale_do rm_loc
}

src_install() {
	local _instdir="/opt/acestream/"
	into ${_instdir}
	exeinto ${_instdir}
	doexe bin/*

	cd ${S}/share
	insinto ${_instdir}share
	doins -r acestream* locale
	newmenu applications/${MY_PN}.desktop ${PN}.desktop
	local s
	for s in 16 32 48 128 256
		do newicon -s ${s} icons/hicolor/${s}x${s}/apps/${MY_PN}.png ${PN}.png
	done

	cd ${S}/lib
	insinto ${_instdir}lib
	doins -r ${MY_PN}
	if use nsplugin; then
		doins -r mozilla
		inst_plugin ${_instdir}lib/mozilla/plugins/libace_plugin.so
	fi
	insopts -m0755
	doins *.so*
	for x in *.so.*.*; do
		dosym ${x} ${_instdir}lib/${x%%.*}.so
	done

	prune_libtool_files --modules
	prepall
	fperms 0755 ${_instdir}lib/${MY_PN}/${MY_PN}-cache-gen

	make_wrapper \
		${PN} \
		"${_instdir}${MY_PN}" \
		"${_instdir}" \
		"${_instdir}lib" \
		"/usr/bin"

	local _cg="${_instdir}lib/${MY_PN}/${MY_PN}-cache-gen"
	local _pd="${_cg%/*}/plugins/"
	if [[ "${ROOT}" == "/" ]] && [[ -x "${_cg}" ]] ; then
		ebegin "Running ${_cg##*/} on ${_pd}"
		LD_LIBRARY_PATH="${ED}${_cg/${MY_PN}*/}" \
			"${ED}${_cg}" -f "${ED}${_pd}"
		eend $?
	else
		ewarn "We cannot run ${_cg##*/} (most likely ROOT!=/)"
		ewarn "Please run manually"
		ewarn "'${_cg} -f ${_pd}'"
		ewarn "If you do not do it, ${MY_PN} will take a long time to load."
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
