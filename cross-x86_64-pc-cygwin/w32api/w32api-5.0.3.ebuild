# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

DESCRIPTION="MinGW-w64 Windows API for Cygwin"
HOMEPAGE="http://cygwin.com/"
MY_ARCH="${CTARGET%-pc-cygwin}"
MY_ARCH="${MY_ARCH/i686/x86}"
MY_H="${PN}-headers-${PV}-1"
MY_R="${PN}-runtime-${PV}-1"
MY_PB="${P}-${MY_ARCH}"
MY_PN="mingw-w64"
MY_P="${MY_PN}-v${PV}"
SRC_URI="mirror://cygwin/${MY_ARCH}/release"
SRC_URI="
	!crosscompile_opts_headers-only? (
		mirror://sourceforge/${MY_PN}/${MY_PN}/${MY_PN}-release/${MY_P}.tar.bz2
	)
	crosscompile_opts_headers-only? (
		${SRC_URI}/${PN}-headers/${MY_H}.tar.xz -> ${MY_PB}_inc.tar.xz
		${SRC_URI}/${PN}-runtime/${MY_R}.tar.xz -> ${MY_PB}_lib.tar.xz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip primaryuri"
S="${WORKDIR}"

DEPEND=""

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
	just_headers && return
	S="${WORKDIR}/${MY_P}"
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -m*=*
	strip-flags
	unset AR RANLIB
}

src_configure() {
	just_headers && return
	local _l
	if [[ -z ${MY_ARCH#*_64} ]]; then
		_l="--enable-lib64 --disable-lib32"
	else
		_l="--disable-lib64 --enable-lib32"
	fi
	econf \
		--enable-w32api \
		--host=${CTARGET} \
		${_l} \
		--with-sysroot="${EPREFIX}/usr/${CTARGET}"
}

src_compile() {
	just_headers && return
	default
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr
		doins -r usr/{lib,include}
	else
		emake \
			DESTDIR="${D}usr/${CTARGET}" \
			install
	fi
}
