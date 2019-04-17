# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="
cs de el en_GB es fr it nn pl pt pt_PT ru sv zh
"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
EGIT_REPO_URI="https://github.com/${PN^}/${PN}.git"
inherit gnome2 python-any-r1 waf-utils l10n git-r3 toolchain-funcs
if [[ -n ${PV%%*9999} ]]; then
	MY_PV="d686076"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	EGIT_COMMIT="${MY_PV/_/-}"
	KEYWORDS="~amd64 ~x86"
fi
SRC_URI=""

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"

LICENSE="GPL-2"
SLOT="${PV%%.*}"
IUSE="alsa bindist bundled-libs +c++0x debug doc jack hid nls phone-home sanitize sse vst"
REQUIRED_USE="
	|| ( alsa jack )
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	dev-cpp/gtkmm:2.4
	sci-libs/fftw:3.0
	media-libs/flac
	media-libs/libogg
	media-libs/fontconfig
	alsa? ( media-libs/alsa-lib )
	media-libs/aubio
	dev-libs/libxml2:2
	media-libs/libsamplerate
	media-libs/lv2
	media-libs/suil
	media-libs/lilv
	media-libs/liblrdf
	net-misc/curl
	media-libs/libsndfile
	jack? ( virtual/jack )
	!bundled-libs? (
		media-libs/libltc
		media-libs/qm-dsp
		hid? ( dev-libs/hidapi )
	)
	media-libs/liblo
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	media-libs/rubberband
	media-sound/fluidsynth
	sys-apps/util-linux
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/boost
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )
"

PATCHES=(
)
DOCS=( README TRANSLATORS doc/monitor_modes.pdf )

src_prepare() {
	default
	my_lcmsg() {
		rm -f {gtk2_ardour,gtk2_ardour/appdata,libs/ardour,libs/gtkmm2ext}/po/${1}.po
	}
	sed -e 's:AudioEditing:X-&:' -i gtk2_ardour/ardour.desktop.in
	sed -e 's:USE_EXTERNAL_LIBS:CANT_&:' -i libs/zita-convolver/wscript
	use nls && l10n_for_each_disabled_locale_do my_lcmsg
	grep -rl '/\<lib\>' | xargs sed -e "s:/\<lib\>:/$(get_libdir):g" -i
}

src_configure() {
	my_use() {
		usex $1 --${2:-${1}} --no-${2:-${1}}
	}
	local wafargs=(
		--configdir=/etc
		--noconfirm
		--versioned
		--freedesktop
		--keepflags
		--with-backends="$(usev alsa),$(usev jack)"
		$(my_use vst lxvst)
		$(my_use nls)
		$(my_use phone-home)
		$(my_use sse fpu-optimization)
		$(usex bindist '--freebie' '')
		$(usex debug '--debug-symbols --rt-alloc-debug' '')
		$(usex c++0x '--cxx11' '')
		$(usex sanitize '--address-sanitizer' '')
		$(usex bundled-libs '' '--use-external-libs')
		$(usex doc '--docs' '')
	)
	PKGCONFIG="$(tc-getPKG_CONFIG)" \
	waf-utils_src_configure "${wafargs[@]}"
}

src_compile() {
	"${WAF_BINARY}" \
		--jobs=$(makeopts_jobs) --verbose \
		build $(usex nls i18n '') || die
}

src_install() {
	waf-utils_src_install
	newicon gtk2_ardour/icons/${PN}-app-icon_osx.png ${PN}${SLOT}.png
	domenu build/gtk2_ardour/${PN}${SLOT}.desktop
	insinto /usr/share/mime/packages
	newins build/gtk2_ardour/${PN}.xml ${PN}${SLOT}.xml
}
