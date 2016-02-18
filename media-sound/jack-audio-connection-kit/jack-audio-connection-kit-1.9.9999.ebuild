# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
inherit eutils python-single-r1 waf-utils multilib-minimal
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"
else
	inherit vcs-snapshot
	MY_PV="4db015a"
	SRC_URI="mirror://githubcl/jackaudio/jack2/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa celt classic dbus debug doc +examples libsamplerate opus pam readline sndfile test"

REQUIRED_USE="
	|| ( classic dbus )
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	${PYTHON_DEPS}
	celt? ( media-libs/celt:0[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opus[${MULTILIB_USEDEP},custom-modes] )
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	dbus? (
		dev-libs/expat[${MULTILIB_USEDEP}]
		sys-apps/dbus[${MULTILIB_USEDEP}]
	)
	examples? (
		sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
		libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
		readline? ( sys-libs/readline:0[${MULTILIB_USEDEP}] )
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
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	pam? ( sys-auth/realtime-base )
"
DOCS=( ChangeLog README README_NETJACK2 TODO )

src_prepare() {
	use examples || sed \
		-e '/example-clients/s:[a-z]\+\.recurse:print:' \
		-i wscript
	use test || sed -e '/tests/d' -i wscript
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mywafconfargs=(
		--htmldir="/usr/share/doc/${PF}/html"
		$(usex dbus --dbus "")
		$(usex classic --classic "")
		$(usex debug --debug "")
		--doxygen=$(usex doc)
		--alsa=$(usex alsa)
		--celt=$(usex celt)
		--opus=$(usex opus)
		--samplerate=$(usex libsamplerate)
		--sndfile=$(usex sndfile)
		--readline=$(usex readline)
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
	WAF_BINARY="${BUILD_DIR}"/waf \
		waf-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
}
