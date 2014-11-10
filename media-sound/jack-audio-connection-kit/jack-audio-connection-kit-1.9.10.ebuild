# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-audio-connection-kit/jack-audio-connection-kit-0.124.1.ebuild,v 1.1 2014/11/02 18:02:05 aballier Exp $

EAPI=5

inherit flag-o-matic waf-utils eutils multilib multilib-minimal
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"
else
	MY_P="${PN%%-*}-${PV}"
	SRC_URI="https://dl.dropboxusercontent.com/u/28869550/${MY_P}.tar.bz2"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa celt classic dbus debug doc eigen +examples libsamplerate opus portaudio readline sndfile test"

RDEPEND="
	portaudio? ( media-libs/portaudio[${MULTILIB_USEDEP}] )
	celt? ( media-libs/celt:0[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opus[${MULTILIB_USEDEP},custom-modes] )
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	eigen? ( dev-cpp/eigen:3 )
	examples? (
		sndfile? ( media-libs/libsndfile )
		libsamplerate? ( media-libs/libsamplerate )
		readline? ( sys-libs/readline )
	)
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	${RDEPEND}
	alsa? ( sys-process/lsof )
"
DOCS=( ChangeLog README README_NETJACK2 TODO )

src_prepare() {
	use examples || sed -e '/example-clients/d' -i wscript
	use test || sed -e '/tests/d' -i wscript
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mywafconfargs=(
		$(usex dbus --dbus "")
		$(usex classic --classic "")
		$(usex doc --doxygen "")
		$(usex debug --debug "")
		$(usex alsa --alsa "")
		$(usex portaudio --portaudio "")
		--enable-pkg-config-dbus-service-dir
	)

	WAF_BINARY="${BUILD_DIR}/waf" \
		waf-utils_src_configure ${mywafconfargs[@]}
}

multilib_src_compile() {
	WAF_BINARY="${BUILD_DIR}/waf" \
		waf-utils_src_compile
}

multilib_src_install() {
	WAF_BINARY="${BUILD_DIR}/waf" \
		waf-utils_src_install
}
