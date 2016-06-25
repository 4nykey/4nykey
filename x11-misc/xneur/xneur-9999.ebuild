# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PLOCALES="be de ro ru uk"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="
		https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz
		https://github.com/AndrewCrewKuznetsov/xneur-devel/raw/master/dists/${PV}/${PN}_${PV}.orig.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit l10n autotools

DESCRIPTION="An utility for keyboard layout switching"
HOMEPAGE="http://www.xneur.ru/"

LICENSE="GPL-2"
SLOT="0"
IUSE="aspell enchant alsa debug gstreamer gtk3 keylogger libnotify nls openal xosd"

DEPEND="
	>=dev-libs/libpcre-5.0
	sys-libs/zlib
	>=x11-libs/libX11-1.1
	x11-libs/libXtst
	gstreamer? ( >=media-libs/gstreamer-0.10.6 )
	openal? ( >=media-libs/freealut-1.0.1 )
	alsa? ( >=media-sound/alsa-utils-1.0.17 )
	libnotify? (
		>=x11-libs/libnotify-0.4.0
		gtk3? ( x11-libs/gtk+:3 )
		!gtk3? ( x11-libs/gtk+:2 )
	)
	aspell? ( app-text/aspell )
	enchant? ( app-text/enchant )
	xosd? ( x11-libs/xosd )
"
RDEPEND="
	${DEPEND}
	gstreamer? (
		media-libs/gst-plugins-good
		media-plugins/gst-plugins-alsa
	)
	nls? ( virtual/libintl )
"
DEPEND="
	${DEPEND}
	>=dev-util/pkgconfig-0.20
	nls? ( sys-devel/gettext )
"

REQUIRED_USE="
	?? ( gstreamer openal alsa )
	?? ( aspell enchant )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local x _snd _gtk _spl
	_snd=$(usev gstreamer)$(usev openal)$(usev alsa)
	_snd=${_snd:-no}
	_spl=$(usev aspell)$(usev enchant)
	_spl=${_spl:-no}
	_gtk="$(usex libnotify $(usex gtk3 gtk3 gtk2) no)"

	local myeconfargs=(
		--with-sound=${_snd}
		--with-gtk=${_gtk}
		--with-spell=${_spl}
		$(use_with debug)
		$(use_enable nls)
		$(use_with xosd)
		$(use_with libnotify)
		$(use_with keylogger)
	)

	econf ${myeconfargs[@]}
	emake clean
}
