# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="
cs de el en_GB es fr it ja nn pl pt pt_PT ru sv zh
"
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE='threads(+)'
WAF_BINARY="${S}/waf"
EGIT_REPO_URI="https://github.com/${PN^}/${PN}.git"
inherit python-any-r1 plocale git-r3 toolchain-funcs multiprocessing desktop xdg
if [[ -n ${PV%%*9999} ]]; then
	MY_PV="f744b5f"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	EGIT_COMMIT="${MY_PV/_/-}"
	KEYWORDS="~amd64"
fi
SRC_URI=""

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="https://ardour.org/"

LICENSE="GPL-2"
SLOT="${PV%%.*}"
IUSE="
alsa bindist bundled-libs debug doc jack hid nls pulseaudio phone-home
sanitize sse vst
"
REQUIRED_USE="
	|| ( alsa jack pulseaudio )
"

RDEPEND="
	dev-cpp/gtkmm:2.4
	sci-libs/fftw:3.0[threads]
	media-libs/flac
	media-libs/libogg
	media-libs/fontconfig
	alsa? ( media-libs/alsa-lib )
	media-libs/aubio
	dev-libs/libxml2:2
	media-libs/libsamplerate
	media-libs/lv2
	media-libs/suil[gtk2]
	media-libs/lilv
	media-libs/liblrdf
	net-misc/curl
	media-libs/libsndfile
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	!bundled-libs? (
		media-libs/libltc
		hid? ( dev-libs/hidapi )
		>=media-sound/fluidsynth-2.0.1
	)
	media-libs/liblo
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	media-libs/rubberband
	sys-apps/util-linux
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-fftw3f.diff
	"${FILESDIR}"/${PN}-ardourcp.diff
)
DOCS=( README TRANSLATORS doc/monitor_modes.pdf )

src_prepare() {
	my_lcmsg() {
		rm -f {gtk2_ardour,gtk2_ardour/appdata,libs/ardour,libs/gtkmm2ext}/po/${1}.po
	}
	plocale_for_each_disabled_locale my_lcmsg
	sed -e 's:AudioEditing:X-&:' -i gtk2_ardour/ardour.desktop.in
	sed -e 's:share/appdata:share/metainfo:' -i gtk2_ardour/wscript
	sed -e 's:USE_EXTERNAL_LIBS:DONT_USE_EXTERNAL_LIB:' -i libs/qm-dsp/wscript
	grep -rl '/\<lib\>' | xargs sed -e "s:/\<lib\>:/$(get_libdir):g" -i
	default
}

src_configure() {
	my_use() {
		usex $1 --${2:-${1}} --no-${2:-${1}}
	}
	local wafargs=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--configdir=/etc
		--noconfirm
		--versioned
		--freedesktop
		--keepflags
		--with-backends="dummy,$(usev alsa),$(usev jack),$(usev pulseaudio)"
		$(my_use vst lxvst)
		$(my_use vst vst3)
		$(my_use nls)
		$(my_use phone-home)
		$(my_use sse fpu-optimization)
		$(usex bindist '--freebie' '')
		$(usex debug '--debug-symbols --rt-alloc-debug' '')
		$(usex sanitize '--address-sanitizer' '')
		$(usex bundled-libs '' '--use-external-libs')
		$(usex doc '--docs' '')
	)

	tc-export AR CC CPP CXX RANLIB

	set -- "${WAF_BINARY}" "${wafargs[@]}" configure
	echo "${@}"

	LINKFLAGS="${LDFLAGS}" \
	PKGCONFIG="$(tc-getPKG_CONFIG)" \
	${EPYTHON} "${@}" || die "configure failed"
}

src_compile() {
	"${WAF_BINARY}" \
		--jobs=$(makeopts_jobs) --verbose \
		build $(usex nls i18n '') || die "build failed"
}

src_install() {
	"${WAF_BINARY}" --destdir="${ED}" install || die "install failed"
	einstalldocs
	newicon gtk2_ardour/icons/${PN}-app-icon_osx.png ${PN}${SLOT}.png
	domenu build/gtk2_ardour/${PN}${SLOT}.desktop
	insinto /usr/share/mime/packages
	newins build/gtk2_ardour/${PN}.xml ${PN}${SLOT}.xml
}
