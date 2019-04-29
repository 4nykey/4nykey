# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be de ro ru uk"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"
else
	inherit vcs-snapshot
	MY_PV="ee27c77"
	SRC_URI="
		mirror://githubcl/AndrewCrewKuznetsov/xneur-devel/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit l10n autotools

DESCRIPTION="An utility for keyboard layout switching"
HOMEPAGE="https://xneur.ru"

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
		media-libs/gst-plugins-good:1.0
	)
	nls? ( virtual/libintl )
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
	dev-util/intltool
	nls? ( sys-devel/gettext )
"

REQUIRED_USE="
	?? ( gstreamer openal alsa )
	?? ( aspell enchant )
"
S="${WORKDIR}/${P}/${PN}"

src_prepare() {
	default
	sed \
		-e '/Libs:/s:@libdir@:${libdir}:' \
		-e '/Libs:/s: @LDFLAGS@::' \
		-e '/Cflags:/s:@includedir@:${includedir}:' \
		-i "${S}"/xn*.pc.in
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
		$(use_with debug)
		$(use_enable nls)
		$(use_with xosd)
		$(use_with libnotify)
		$(use_with keylogger)
	)

	econf ${myeconfargs[@]}
}
