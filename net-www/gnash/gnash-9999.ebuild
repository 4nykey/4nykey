# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools bzr kde-functions multilib nsplugins qt3 confutils

set-kdedir 3.5

EAPI="1"
DESCRIPTION="Gnash is a GNU Flash movie player that supports many SWF v7 features"
HOMEPAGE="http://www.gnu.org/software/gnash/"

EBZR_BRANCH="trunk"
EBZR_REPO_URI="http://bzr.savannah.gnu.org/r/gnash/"
EBZR_PATCHES="${P}*.patch"
EBZR_BOOTSTRAP="eautoreconf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="
agg cairo cygnal doc fb ffmpeg fltk gnome gstreamer gtk kde neon nsplugin
opengl parallel sdl video_cards_i810 X
"

RDEPEND="
	>dev-libs/boost-1.34
	dev-libs/libxml2
	media-libs/jpeg
	media-libs/libpng
	net-misc/curl
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-proto/xproto
	agg? ( x11-libs/agg )
	cairo? ( x11-libs/cairo )
	doc? (
		>=app-text/docbook2X-0.8.8
		app-text/docbook-sgml-utils
	)
	opengl?	(
		virtual/opengl
		gtk? ( x11-libs/gtkglext )
	)
	ffmpeg?	(
		media-libs/libsdl
		media-video/ffmpeg
	)
	gstreamer? (
		media-plugins/gst-plugins-ffmpeg
		media-plugins/gst-plugins-mad
		media-plugins/gst-plugins-meta
		gnome? (
			media-plugins/gst-plugins-gnomevfs
		)
		neon? (
			>=media-plugins/gst-plugins-neon-0.10.7
		)
	)
	gtk? (
		dev-libs/atk
		dev-libs/glib
		>x11-libs/gtk+-2
		x11-libs/pango
	)
	kde? ( kde-base/kdelibs:3.5 )
	sdl? ( media-libs/libsdl )
"

DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

pkg_setup() {
	# require one renderer...
	confutils_require_any agg cairo opengl
	confutils_use_conflict agg cairo opengl
	confutils_use_conflict cairo opengl
	# ...and at least one gui toolkit
	confutils_require_any kde gtk sdl fb fltk
	# cairo only goes with gtk
	confutils_use_conflict cairo fb fltk kde sdl
	# opengl not supported with fb and fltk
	confutils_use_conflict opengl fb fltk
	# nsplugin requires gtk
	confutils_use_depend_all nsplugin gtk
	# only one media handler is used
	confutils_use_conflict ffmpeg gstreamer
}

src_compile() {
	local myconf _rend _media _gui _jobs

	# Set nsplugin install directory.
	use nsplugin && myconf+="
		--with-npapi-plugindir=/opt/netscape/plugins
	"

	# Set kde and konqueror plugin directories.
	use kde && myconf+="
		--with-kde-pluginprefix=/usr
		--with-kde-plugindir=/usr/lib/kde3
		--with-kde-appsdatadir=/usr/share/apps/klash
		--with-kde-servicesdir=/usr/share/services
	"

	# Set rendering engine.
	_rend=$(usev agg; usev cairo; usev opengl)

	# Set media handler.
	_media=$(usev gstreamer; usev ffmpeg)
	_media=${_media:-none}

	# Set gui.
	for g in fb fltk gtk kde sdl; do _gui+="$(usev $g),"; done

	econf \
		$(use_enable cygnal cygnal) \
		$(use_enable doc docbook) \
		$(use_enable gnome ghelp) \
		$(use_enable nsplugin npapi) \
		$(use_enable kde kparts) \
		$(use_enable video_cards_i810 i810-lod-bias) \
		$(use_enable X mit-shm) \
		--enable-renderer=${_rend/opengl/ogl} \
		--enable-media=${_media/gstreamer/gst} \
		--with-ffmpeg-incl=/usr/include \
		--enable-gui=${_gui} \
		${myconf} || die "econf failed"

	# Should the ebuild use parallel compiling ?
	use parallel || _jobs="-j1"

	emake ${_jobs} || die "emake failed"
}

src_install() {
	emake ${jobs} DESTDIR="${D}" install || die "emake install failed"
	# Install nsplugin in directory set by --with-npapi-plugindir.
	use nsplugin && emake DESTDIR="${D}" install-plugin
	# Install kde konqueror plugin.
	if use kde; then
		cd "${S}/plugin/klash"
		emake DESTDIR="${D}" install-plugin
	fi
	# Create a symlink in /usr/$(get_libdir)/nsbrowser/plugins to the nsplugin install directory.
	use nsplugin && inst_plugin /opt/netscape/plugins/libgnashplugin.so \
		|| rm -rf "${D}/opt"
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	if use !ffmpeg && use !gstreamer || use gstreamer && ( use !gnome && use !neon ); then
		ewarn "Gnash was built without a media handler and or http handler!"
		ewarn ""
		ewarn "If you want Gnash to support video then you will need to"
		ewarn "rebuild Gnash with either the ffmpeg or gstreamer use flags set."
		ewarn "If you use gstreamer you will also need to set one of"
		ewarn "the two http handler use flags: gnome or neon."
	fi

	ewarn "gnash is still in heavy development"
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "but instead to the gnash devs"
}
