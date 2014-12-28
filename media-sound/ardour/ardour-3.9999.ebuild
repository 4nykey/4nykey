# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PLOCALES="
cs de el en_GB es fr it nn pl pt pt_PT ru sv zh
"
inherit fdo-mime gnome2-utils waf-utils l10n git-r3 base

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
EGIT_REPO_URI="git://git.ardour.org/ardour/ardour.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="alsa bindist bundled-libs -c++0x custom-cflags debug doc jack lv2 nls osc phone-home sanitize sse wiimote"
REQUIRED_USE="|| ( alsa jack )"

RDEPEND="
	dev-cpp/gtkmm:2.4
	sci-libs/fftw:3.0
	media-libs/flac
	media-libs/libogg
	media-libs/fontconfig
	alsa? ( media-libs/alsa-lib )
	media-libs/aubio
	dev-libs/libxml2:2
	media-libs/liblrdf
	media-libs/libsamplerate
	lv2? (
		media-libs/suil
		media-libs/lilv
	)
	net-misc/curl
	media-libs/libsndfile
	jack? ( media-sound/jack-audio-connection-kit )
	!bundled-libs? (
		media-libs/libltc
	)
	osc? ( media-libs/liblo )
	wiimote? (
		net-wireless/bluez
		app-misc/cwiid
	)
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	media-libs/rubberband
	sys-apps/util-linux
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )
"

PATCHES= #( "${FILESDIR}"/${PN}${SLOT}*.diff )
DOCS=( README TRANSLATORS doc/monitor_modes.pdf )

my_use() {
	usex $1 --${2:-${1}} --no-${2:-${1}}
}

my_lcmsg() {
	rm -f {gtk2_ardour,libs/ardour,libs/gtkmm2ext}/po/${1}.po
}

src_prepare() {
	sed \
		-e 's:AudioEditing:X-&:' \
		-i gtk2_ardour/ardour3.desktop.in
	sed \
		-e '/clearlooks-newer/d' \
		-i wscript
	use custom-cflags && sed \
		-e 's:\(prepend_opt_flags = \)True:\1False:' \
		-i wscript
	use nls && l10n_for_each_disabled_locale_do my_lcmsg
	base_src_prepare
}

src_configure() {
	local wafargs=(
		--configdir=/etc
		--noconfirm
		--versioned
		--freedesktop
		--with-backends="$(usev alsa),$(usev jack)"
		$(my_use lv2)
		$(my_use nls)
		$(my_use phone-home)
		$(my_use sse fpu-optimization)
		$(usex bindist '--freebie' '')
		$(usex debug '' '--optimize')
		$(usex c++0x '--cxx11' '')
		$(usex sanitize '--address-sanitizer' '')
		$(usex bundled-libs '' '--use-external-libs')
		$(usex doc '--docs' '')
	)

	waf-utils_src_configure "${wafargs[@]}"
}

src_compile() {
	"${WAF_BINARY}" --jobs=$(makeopts_jobs) --verbose build $(usex nls i18n '')
}

src_install() {
	waf-utils_src_install
	newicon icons/icon/ardour_icon_mac.png ${PN}${SLOT}.png
	newmenu gtk2_ardour/ardour3.desktop.in ${PN}${SLOT}.desktop
	insinto /usr/share/mime/packages
	doins gtk2_ardour/${PN}${SLOT}.xml
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
