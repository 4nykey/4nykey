# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be de ro ru uk"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="
		https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz
		mirror://githubraw/AndrewCrewKuznetsov/xneur-devel/master/dists/${PV}/${PN}_${PV}.orig.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit l10n autotools

DESCRIPTION="An utility for keyboard layout switching"
HOMEPAGE="http://www.xneur.ru/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa aspell debug enchant gstreamer keylogger libnotify nls openal xosd"

DEPEND="
	sys-libs/zlib
	x11-libs/libXi
	gstreamer? ( media-libs/gstreamer:1.0 )
	openal? ( media-libs/freealut )
	>=dev-libs/libpcre-5.0
	enchant? ( app-text/enchant )
	aspell? ( app-text/aspell )
	xosd? ( x11-libs/xosd )
	libnotify? (
		>=x11-libs/libnotify-0.4.0
		x11-libs/gtk+:2
	)
"
RDEPEND="
	${DEPEND}
	alsa? ( media-sound/alsa-utils )
	gstreamer? (
		media-libs/gst-plugins-good
		media-plugins/gst-plugins-alsa
	)
	nls? ( virtual/libintl )
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

REQUIRED_USE="
	?? ( gstreamer openal alsa )
	?? ( aspell enchant )
"

src_prepare() {
	default
	sed \
		-e '/Libs:/s:@libdir@:${libdir}:' \
		-e '/Libs:/s: @LDFLAGS@::' \
		-e '/Cflags:/s:@includedir@:${includedir}:' \
		-i "${S}"/xn*.pc.in
	[[ -n ${PV%%*9999} ]] && return
	sed -e '/\<INSTALL\>/d' -i "${S}"/Makefile.am
	eautoreconf
}

src_configure() {
	local _snd _spl
	_snd=$(usev gstreamer)$(usev openal)$(usev alsa)
	_snd=${_snd:-no}
	_spl=$(usev aspell)$(usev enchant)
	_spl=${_spl:-no}

	local myeconfargs=(
		--with-sound=${_snd}
		--with-spell=${_spl}
		--with-gtk=$(usex libnotify gtk2)
		$(use_with debug)
		$(use_enable nls)
		$(use_with xosd)
		$(use_with libnotify)
		$(use_with keylogger)
	)

	econf ${myeconfargs[@]}
	[[ -z ${PV%%*9999} ]] && emake clean
}
