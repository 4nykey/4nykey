# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-audio-connection-kit/jack-audio-connection-kit-0.124.1.ebuild,v 1.1 2014/11/02 18:02:05 aballier Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )
PYTHON_REQ_USE='threads(+)'
inherit flag-o-matic python-any-r1 waf-utils eutils multilib multilib-minimal
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/jackaudio/jack2/tar.gz/v${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
fi

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa celt classic dbus debug doc eigen +examples libsamplerate opus readline sndfile test"

RDEPEND="
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
	${PYTHON_DEPS}
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
	sed \
		-e 's:\(html_docs_source_dir = \).*:\1"html":' \
		-e "s:\(html_[a-z_]*install_dir = \).*:\1bld.options.destdir + bld.env['PREFIX'] + \"/share/doc/${PF}/html\":" \
		-i wscript
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
